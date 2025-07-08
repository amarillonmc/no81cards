--墨染山河 T型帛画
local s,id,o=GetID()
Duel.LoadScript("c33201381.lua")
function s.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkType,TYPE_EFFECT),2,99,s.lcheck)
	c:EnableReviveLimit()
	--CopyEffect
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_TOKEN)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetHintTiming(0,TIMING_END_PHASE)
	e1:SetCountLimit(1,id)
	e1:SetTarget(s.etg)
	e1:SetOperation(s.eop)
	c:RegisterEffect(e1)
end
function s.spfilter(c)
	return c.VHisc_CNTreasure
end
function s.lcheck(g)
	return g:IsExists(s.spfilter,1,nil)
end
s.VHisc_MRSH=true
s.VHisc_CNTreasure=true

function s.filter(c)
	return c.VHisc_MRSH and not c:IsCode(id) and not c:IsCode(33201356)
end
function s.etg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return chkc:IsLocation(LOCATION_ONFIELD+LOCATION_GRAVE) and chkc:IsControler(tp) and s.filter(chkc)  end
	if chk==0 then return Duel.IsExistingTarget(s.filter,tp,LOCATION_ONFIELD+LOCATION_GRAVE,0,1,nil) and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,s.filter,tp,LOCATION_ONFIELD+LOCATION_GRAVE,0,1,1,nil)
end
function s.eop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 then
		local cid=tc:GetOriginalCode()
		e:SetLabel(cid,cid-40)
		VHisc_MRSH.gop(e,tp,eg,ep,ev,re,r,rp)
	end
end