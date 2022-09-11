--冥王汲魂波
local s,id,o=GetID()
function s.initial_effect(c)
	aux.AddCodeList(c,33201009)
	--remove and token
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_REMOVE+CATEGORY_TOKEN)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetTarget(s.rdtg)
	e1:SetOperation(s.rdop)
	c:RegisterEffect(e1)   
end

function s.rmfilter(c)
	return c:IsRace(RACE_ZOMBIE) and c:IsAbleToRemove()
end
function s.rdtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(1-tp) and chkc:IsLocation(LOCATION_GRAVE) and s.rmfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(s.rmfilter,tp,LOCATION_GRAVE,0,1,nil) end
	local fc=Duel.GetLocationCount(tp,LOCATION_SZONE)
	local rmc=3
	if fc<3 then rmc=fc end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectTarget(tp,s.rmfilter,tp,LOCATION_GRAVE,0,1,rmc,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,g:GetCount(),tp,LOCATION_GRAVE)
end
function s.rdop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local tg=g:Filter(Card.IsRelateToEffect,nil,e)
	local fc=Duel.GetLocationCount(tp,LOCATION_SZONE)
	if fc>=tg:GetCount() then
		for tc in aux.Next(tg) do
			if Duel.Remove(tc,POS_FACEUP,REASON_EFFECT) then
				local token=Duel.CreateToken(tp,33201009)
				Duel.MoveToField(token,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
				local lv=tc:GetOriginalLevel()
				if lv>12 then lv=12 end
				if lv<1 then lv=1 end
				local e1=Effect.CreateEffect(e:GetHandler())
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_CHANGE_LEVEL)
				e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
				e1:SetValue(lv)
				token:RegisterEffect(e1,true)
				local e2=Effect.CreateEffect(e:GetHandler())
				e2:SetType(EFFECT_TYPE_SINGLE)
				e2:SetCode(EFFECT_CHANGE_TYPE)
				e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
				e2:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
				e2:SetValue(TYPE_CONTINUOUS+TYPE_SPELL)
				token:RegisterEffect(e2,true)
				token:RegisterFlagEffect(0,RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(33201009,lv))
			end
		end
	end
end