--PNC 安冬妮娜
function c77029003.initial_effect(c)
	--disable 
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DISABLE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_TO_GRAVE)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,77029003)
	e1:SetCondition(c77029003.thcon)
	e1:SetCost(c77029003.thcost)
	e1:SetTarget(c77029003.thtg)
	e1:SetOperation(c77029003.thop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DISABLE)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_REMOVE)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,77029003)
	e2:SetCost(c77029003.thcost)
	e2:SetTarget(c77029003.thtg)
	e2:SetOperation(c77029003.thop)
	c:RegisterEffect(e2)	
end












