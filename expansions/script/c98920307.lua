--闪刀术式-跃迁引擎
function c98920307.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCondition(c98920307.condition)
	e1:SetTarget(c98920307.target)
	e1:SetOperation(c98920307.activate)
	c:RegisterEffect(e1)
end
function c98920307.cfilter(c)
	return c:GetSequence()<5
end
function c98920307.condition(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsExistingMatchingCard(c98920307.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c98920307.xyzfilter(c,tp)
	return c:IsFaceup() and c:IsType(TYPE_XYZ)
		and Duel.IsExistingTarget(c98920307.matfilter,tp,0,LOCATION_MZONE,1,nil)
end
function c98920307.matfilter(c,atk)
	return c:IsFaceup() and c:IsCanOverlay()
end
function c98920307.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return Duel.IsExistingTarget(c98920307.xyzfilter,tp,LOCATION_MZONE,0,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,c98920307.xyzfilter,tp,LOCATION_MZONE,0,1,1,nil,tp)
	local tc=g:GetFirst()
	e:SetLabelObject(tc)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c98920307.matfilter,tp,0,LOCATION_MZONE,1,1,nil,tc:GetAttack())
end
function c98920307.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local lc=tg:GetFirst()
	if lc==tc then lc=tg:GetNext() end
	if tc:IsRelateToEffect(e) and tc:IsControler(tp) and not tc:IsImmuneToEffect(e) and lc:IsRelateToEffect(e) and lc:IsControler(1-tp) and not lc:IsImmuneToEffect(e) then
		local og=lc:GetOverlayGroup()
		if og:GetCount()>0 then
			Duel.SendtoGrave(og,REASON_RULE)
		end
		if Duel.Overlay(tc,Group.FromCards(lc))~=0 then		  
			if Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,0,LOCATION_HAND,1,nil) and Duel.GetMatchingGroupCount(Card.IsType,tp,LOCATION_GRAVE,0,nil,TYPE_SPELL)>=3 and Duel.SelectYesNo(tp,aux.Stringid(98920307,0)) then
				local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,LOCATION_HAND,nil)
				if g:GetCount()>0 then
					local sg=g:RandomSelect(tp,1)
					Duel.Remove(sg,POS_FACEDOWN,REASON_EFFECT)
				end
			end
		end
   end
end