--艹！DIY卡的LUA又写错了！
local m=33701435
local cm=_G["c"..m]
function cm.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(2,m+EFFECT_COUNT_CODE_DUEL)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
	
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CODE)
	local ac=Duel.AnnounceCard(tp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_CHAIN_SOLVING)
	e1:SetLabel(ac)
	e1:SetCondition(cm.discon)
	e1:SetOperation(cm.disop)
	Duel.RegisterEffect(e1,tp)
end
function cm.discon(e,tp,eg,ep,ev,re,r,rp)
	local ac=e:GetLabel()
	return re:GetHandler():IsCode(ac)
end
function cm.disop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,m)
	Duel.ChangeChainOperation(ev,cm.repop) 
end
function cm.repop(e,tp,eg,ep,ev,re,r,rp)
end
