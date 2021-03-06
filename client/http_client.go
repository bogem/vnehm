// Copyright 2016 Albert Nigmatzianov. All rights reserved.
// Use of this source code is governed by a MIT-style
// license that can be found in the LICENSE file.

package client

import (
	"errors"
	"fmt"
	"net/url"

	"github.com/bogem/vnehm/ui"
	"github.com/valyala/fasthttp"
)

const apiURL = "https://api.vk.com/method"

var (
	ErrForbidden = errors.New("403 - Forbidden")
	ErrNotFound  = errors.New("404 - Not Found")
)

func getTracks(params url.Values) ([]byte, error) {
	uri := formTracksURI(params)
	return get(uri)
}

func formTracksURI(params url.Values) string {
	return apiURL + "/audio.get?" + params.Encode()
}

func search(params url.Values) ([]byte, error) {
	uri := formSearchURI(params)
	return get(uri)
}

func formSearchURI(params url.Values) string {
	return apiURL + "/audio.search?" + params.Encode()
}

func wallAudios(params url.Values) ([]byte, error) {
	uri := formWallAudiosURI(params)
	return get(uri)
}

func formWallAudiosURI(params url.Values) string {
	return apiURL + "/wall.getById?" + params.Encode()
}

func get(uri string) ([]byte, error) {
	statusCode, body, err := fasthttp.Get(nil, uri)
	if err != nil {
		return nil, err
	}
	if err := handleStatusCode(statusCode); err != nil {
		return nil, err
	}
	return body, nil
}

func handleStatusCode(statusCode int) error {
	switch {
	case statusCode == 403:
		return ErrForbidden
	case statusCode == 404:
		return ErrNotFound
	case statusCode >= 300 && statusCode < 500:
		return fmt.Errorf("invalid response from VK: %v", statusCode)
	case statusCode >= 500:
		ui.Term("there is a problem by VK. Please wait a while", nil)
	}
	return nil
}
