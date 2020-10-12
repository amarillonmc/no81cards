--个人行动-黄昏
function c79029339.initial_effect(c)
	--ac
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_RECOVER)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,79029339)
	e1:SetTarget(c79029339.actg)
	e1:SetOperation(c79029339.acop)
	c:RegisterEffect(e1)
	--re
	local e3=Effect.CreateEffect(c)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCountLimit(1,09029339)
	e3:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetCost(aux.bfgcost)
	e3:SetTarget(c79029339.retg)
	e3:SetOperation(c79029339.reop)
	c:RegisterEffect(e3)
end
function c79029339.acfil(c)
	return c:GetOverlayCount()>0
end
function c79029339.actg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c79029339.acfil,tp,LOCATION_MZONE,0,1,nil) end
	local g=Duel.SelectMatchingCard(tp,c79029339.acfil,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SetTargetCard(g)
end
function c79029339.acop(e,tp,eg,ep,ev,re,r,rp)
	Debug.Message("莱万汀！")
	Duel.Hint(HINT_SOUND,0,aux.Stringid(79029339,0))
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	local og=tc:GetOverlayGroup() 
	local x=Duel.SendtoGrave(og,REASON_EFFECT)
	if x==0 then return end
	Duel.Recover(tp,x*1000,REASON_EFFECT)
	--
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetLabelObject(tc)
	e1:SetOperation(c79029339.ovop)
	Duel.RegisterEffect(e1,tp)
end
function c79029339.ovop(e,tp,eg,ep,ev,re,r,rp)
	e:Reset()
	local tc=e:GetLabelObject()
	if tc:IsLocation(LOCATION_MZONE) and Duel.IsExistingMatchingCard(aux.TRUE,tp,0,LOCATION_HAND+LOCATION_ONFIELD,1,nil) and Duel.SelectEffectYesNo(tp,e:GetHandler()) then
	Duel.Hint(HINT_CARD,0,79029339)
	Debug.Message("理所当然。")
	Duel.Hint(HINT_SOUND,0,aux.Stringid(79029339,1))
	g=Duel.SelectMatchingCard(tp,Card.IsCanOverlay,tp,0,LOCATION_HAND+LOCATION_ONFIELD,1,1,nil)
	Duel.Overlay(tc,g)
	end
end
function c79029339.retg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then Duel.IsExistingMatchingCard(Card.IsCode,tp,LOCATION_MZONE,0,1,nil,79029325) end
end
function c79029339.reop(e,tp,eg,ep,ev,re,r,rp)
	Debug.Message("我会在这里不是因为我需要在这里，只是因为我想而已。")
	Duel.Hint(HINT_SOUND,0,aux.Stringid(79029339,2))
	local c=e:GetHandler()
	--remove
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_IGNORE_RANGE+EFFECT_FLAG_IGNORE_IMMUNE)
	e2:SetCode(EFFECT_TO_GRAVE_REDIRECT)
	e2:SetTargetRange(0xff,0xff)
	e2:SetReset(RESET_PHASE+PHASE_END)
	e2:SetValue(LOCATION_REMOVED)
	Duel.RegisterEffect(e2,tp)
end








