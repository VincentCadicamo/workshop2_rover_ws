# Use the official ROS 2 Humble image with desktop tools (RViz, Gazebo)
FROM osrf/ros:humble-desktop-full

# Set shell to bash
SHELL ["/bin/bash", "-c"]

# Install common dependencies for the whole workshop (run as root)
RUN apt-get update && apt-get install -y \
    sudo \
    python3-pip \
    ros-humble-teleop-twist-keyboard \
    ros-humble-gazebo-ros-pkgs \
    ros-humble-ros2-control \
    ros-humble-ros2-controllers \
    ros-humble-xacro \
  && rm -rf /var/lib/apt/lists/*

# Install colcon tools
RUN pip3 install -U colcon-common-extensions

# Create the non-root user AFTER installations
RUN useradd -ms /bin/bash ros && \
    echo "ros ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers && \
    mkdir -p /home/ros/urc_rover_ws/src && \
    chown -R ros:ros /home/ros

# Switch to ros user
USER ros

# Set the working directory
WORKDIR /home/ros/urc_rover_ws

# Source ROS 2 Humble in the entrypoint
ENTRYPOINT ["/bin/bash", "-c", "source /opt/ros/humble/setup.bash && exec \"$@\""]

RUN echo "source /opt/ros/humble/setup.bash" >> /home/ros/.bashrc

# Default command to keep the container running
CMD ["sleep", "infinity"]
