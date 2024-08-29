# Project setup

## Setup python version

```console
$ pyenv install 3.10
$ pyenv local 3.10
```

## Create a Virtual Environment

To create a virtual environment, you can use the `venv` module that comes with Python.

```console
$ python -m venv .venv
```

## Activate the Virtual Environment

Activate the new virtual environment so that any Python command you run or package you install uses it.

```console
$ source .venv/bin/activate
```

## Install dependencies

```console
$ pip install -r requirements/base.txt
```

## Run the app

```console
$ python main.py
```
