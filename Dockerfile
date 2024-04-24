FROM python:3.10

ARG AIHUB_TOKEN=passmein

ENV PYTHONDONTWRITEBYTECODE=1

ENV PYTHONUNBUFFERED=1

WORKDIR /home/appuser

RUN apt-get update && apt-get install -y libhdf5-serial-dev libgl1-mesa-glx

RUN pip3 install qai-hub

RUN qai-hub configure --api_token ${AIHUB_TOKEN}

RUN mkdir -p /home/appuser/.qai_hub

RUN cp /root/.qai_hub/client.ini /home/appuser/.qai_hub/client.ini

RUN chmod -Rv 777 /home/appuser/.qai_hub/

RUN pip install qai_hub_models

RUN pip3 install "qai-hub[torch]"

RUN pip install "qai_hub_models[yolov7]"

RUN pip install shapely

COPY perf-analysis-mobilenetv2.py /home/appuser/perf-analysis-mobilenetv2.py

COPY run-yolov7.sh /home/appuser/run-yolov7.sh

RUN chmod a+x /home/appuser/run-yolov7.sh

CMD ['python', '/home/appuser/perf-analysis-mobilenetv2.py']
