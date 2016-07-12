+++
date = "2016-07-08"
title = "Deep Learning with AWS"
+++

There are many tutorials on how to leverage Amazon's supreme computing power to perform deep learning tasks. I would like to take this opportunity to contribute to that collection.

I started working with Amazon's EC2 instances for deep learning by reading some of these said tutorials including predominantly:

* [Installing CUDA, OpenCL, and PyOpenCL on AWS EC2](http://vasir.net/blog/opencl/installing-cuda-opencl-pyopencl-on-aws-ec2)
* [Deep Learning Tutorial for Kaggle's Facial Keypoints Detection](https://www.kaggle.com/c/facial-keypoints-detection/details/deep-learning-tutorial)
* [Installing TensorFlow on AWS](https://gist.github.com/erikbern/78ba519b97b440e10640)

I would launch an instance, install the necessary dependencies, and create an AMI. This would be repeated for each deep learning framework that I wanted to use (Theano, Caffe, Tensorflow etc.)

I recently came upon [NVIDIA Docker](https://github.com/NVIDIA/nvidia-docker) and I haven't stopped using it since. I'm only storing one AMI now and it's much faster for me to update the frameworks and their underlying dependencies.
NVIDIA Docker is a thin wrapper for [Docker](https://www.docker.com/what-docker) that can, in addition to the default functionality, discover available GPU devices and their respective driver files.

Throughout this tutorial, I'm going to assume you've selected one of the GPU EC2 instances, running Ubuntu 14.04.4 LTS (Trusty Tahr). Issues might arise if you don't follow.

Following this tutorial, it took roughly 15 minutes, from launching the instance to having a container ready with Keras, Theano, and CUDA.

## **Creating the EC2 Instance**

For starters, I recommend reading [Getting Started with Amazon EC2 Linux Instances](http://docs.aws.amazon.com/AWSEC2/latest/UserGuide/EC2_GetStarted.html).

To summarize,

1. Go to the EC2 page on the AWS Console and click on the blue Launch instance button.

2. Choose the latest stable Ubuntu AMI. You can find it on the Quick Start and Community AMI panes.
{{< figure src="/images/ubuntu.png">}}

3. Select one of the GPU instances: g2.2xlarge (1 GPU), g2.8xlarge (4 GPUs).

4. Choose 'Request Spot Instances' if you want to save up to 90% on instance costs. Spot instances provide computer power at a much cheaper rate but they come with the risk of getting killed unexpectedly (depends on your max bid price). If you can't handle the interruptions and are willing to pay more, stick to the default on-demand instance.

## **Installing the prerequisites**

Connect to your instance. Read [Connecting to Your Linux Instance Using SSH](http://docs.aws.amazon.com/AWSEC2/latest/UserGuide/AccessingInstancesLinux.html) for instructions.
```
ssh -i [my_keypair.pem] ubuntu@[dns_of_ec2_instance]  
```
> Connecting to an instance running Ubuntu using SSH client.

Once you've made your way into the instance, it's time to start installing everything we need to start deep learning.

In order to use NVIDIA Docker, we need to fulfill [Nvidia-docker prerequisites](https://github.com/NVIDIA/nvidia-docker/wiki/Installation#prerequisites).

Update all the default packages on the instance.
```
sudo apt-get update && sudo apt-get upgrade
```

Install Docker on the instance. You need to follow [this](https://docs.docker.com/engine/installation/linux/ubuntulinux/).
The tutorial goes through updating your apt sources, installing the ```linux-image-extra``` kernel package and ```docker-engine```.

To summarize,

```
sudo apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D
```

Create file ```/etc/apt/sources.list.d/docker.list```.

Add line ```deb https://apt.dockerproject.org/repo ubuntu-trusty main```

```
sudo apt-get update
apt-cache policy docker-engine
sudo apt-get install linux-image-extra-$(uname -r)
sudo apt-get install docker-engine
```

If you've followed all of those instructions, you can test it out using the following:
```
sudo docker run hello-world
```

Install the necessary graphics drivers. Read more [here](http://www.howtogeek.com/242045/how-to-get-the-latest-nvidia-amd-or-intel-graphics-drivers-on-ubuntu/).
According to the PPA page, ```nvidia-361``` is the recommended version.
```
sudo add-apt-repository ppa:graphics-drivers/ppa
sudo apt-get update
sudo apt-get install nvidia-361
```

Install ```nvidia-modprobe```. It loads the NVIDIA kernel module and creates NVIDIA character device files.
```
sudo apt-get install nvidia-modprobe
```

## **Installing NVIDIA Docker**
If you've followed the instructions above, the next few should be a breeze. 

Install NVIDIA Docker.
```
wget -P /tmp https://github.com/NVIDIA/nvidia-docker/releases/download/v1.0.0-rc.3/nvidia-docker_1.0.0.rc.3-1_amd64.deb

sudo dpkg -i /tmp/nvidia-docker*.deb && rm /tmp/nvidia-docker*.deb
```
The following instruction can be used to test everything so far. I've also included what should be roughly returned from the command.
```
sudo nvidia-docker run --rm nvidia/cuda nvidia-smi

+-----------------------------------------------------------------------------+
| NVIDIA-SMI 361.45.18              Driver Version: 361.45.18                 |
|-------------------------------+----------------------+----------------------+
| GPU  Name        Persistence-M| Bus-Id        Disp.A | Volatile Uncorr. ECC |
| Fan  Temp  Perf  Pwr:Usage/Cap|         Memory-Usage | GPU-Util  Compute M. |
|===============================+======================+======================|
|   0  GRID K520           Off  | 0000:00:03.0     Off |                  N/A |
| N/A   29C    P8    19W / 125W |     11MiB /  4095MiB |      0%      Default |
+-------------------------------+----------------------+----------------------+

+-----------------------------------------------------------------------------+
| Processes:                                                       GPU Memory |
|  GPU       PID  Type  Process name                               Usage      |
|=============================================================================|
|  No running processes found                                                 |
+-----------------------------------------------------------------------------+
```
I highly recommend creating an AMI at this point in time. You will avoid having to follow this tutorial again.
Read [Creating an AMI EBS](http://docs.aws.amazon.com/AWSEC2/latest/UserGuide/creating-an-ami-ebs.html).

Select a Docker image from [Kaixhin's repository](https://hub.docker.com/u/kaixhin/). Let's pick `kaixhin/cuda-keras` and download it.
```
sudo nvidia-docker pull kaixhin/cuda-keras
```

Create a container with the image.
```
sudo nvidia-docker run -it kaixhin/cuda-keras
```

Voila! You've got yourself a container setup with Keras, Theano and CUDA.

## **Extras**
#### Adding code and data
You've got a container now but no code or data. What is the point?!?!

In the EC2 instance, create a directory where your code and data will reside. You can use ```s3cmd``` to move data from/to Amazon's S3.

```
sudo apt-get install s3cmd
```

One way of moving files onto the container is using docker's ```scp``` command. Unfortunately, with a lot of data and code, this can be quiet a hassle.

I recommend attaching a data volume to a container. Next time you run a container, use the `-v` flag.

```
sudo nvidia-docker -v /home/ubuntu/[HOST_DIR]:/[CONTAINER_DIR] -it kaixhin/cuda-keras
```
cd to `/[CONTAINER_DIR]` and you will find everything that is in the `[HOST_DIR]`. Any changes in `[HOST_DIR]` will be directly reflected in the container (without having to run again).

#### Additional dependencies

Go to [Kaixhin's repository](https://hub.docker.com/u/kaixhin/) and download the Dockerfile related to the image you're interested in building.

Modify the Dockerfile and copy it over to your EC2 instance. I recommend reading [Best practices for writing Dockerfiles](https://docs.docker.com/engine/userguide/eng-image/dockerfile_best-practices/).

Create a directory `[DOCKER_DIR]` and move the modified Dockerfile into that directory.

Run the following:

```
sudo nvidia-docker build [DOCKER_DIR]
```

Next time you run a container, you can use the id of the image you just built.

### Conclusion
I hope you enjoyed my tutorial. Once I've got everything set up, I'll usually run some code, detach from my container and tail the logs from the host.
