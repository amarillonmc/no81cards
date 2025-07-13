--芭斯瓦尔德的祝诞
local cm,m=GetID()
function cm.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--material
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,0))
	e3:SetCategory(CATEGORY_TODECK)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetCountLimit(1,EFFECT_COUNT_CODE_CHAIN)
	e3:SetRange(LOCATION_FZONE+LOCATION_GRAVE)
	e3:SetTarget(cm.mattg)
	e3:SetOperation(cm.matop)
	c:RegisterEffect(e3)	
end
function cm.tgfilter(c,e)
	return c:IsSetCard(0x97b) and c:IsCanBeEffectTarget(e) and c:IsAbleToDeck()
end
function cm.attr(c)
	return c:IsType(TYPE_MONSTER) and c:GetAttribute() or (c:GetType()&0x6)<<8
end
function cm.bfilter(c)
	return c:IsLocation(LOCATION_DECK) and c:IsOriginalSetCard(0x97b) and c:GetOriginalCode()~=m
end
function cm.cfilter(c,code)
	return c:GetOriginalCode()==code
end
function cm.fselect(g,c)
	return g:GetClassCount(cm.attr)==#g and (not c or g:IsContains(c))
end
function cm.mattg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(cm.tgfilter,tp,LOCATION_GRAVE,0,nil,e)
	local g2=Duel.GetMatchingGroup(Card.IsAbleToDeck,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	if chk==0 then return g:CheckSubGroup(cm.fselect,3,3) and (not c:IsLocation(LOCATION_GRAVE) or g:CheckSubGroup(cm.fselect,3,3,c)) and #g2>0 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local tg=Group.CreateGroup()
	if c:IsLocation(LOCATION_GRAVE) then
		tg=g:SelectSubGroup(tp,cm.fselect,false,3,3,c)
	else
		tg=g:SelectSubGroup(tp,cm.fselect,false,3,3)
	end
	Duel.SetTargetCard(tg)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,tg+g2,4,PLAYER_ALL,LOCATION_ONFIELD+LOCATION_GRAVE)
end
function cm.matop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	local g2=Duel.GetMatchingGroup(Card.IsAbleToDeck,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	if #g>0 and #g2>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		local sg=g2:Select(tp,1,1,nil)
		if Duel.SendtoDeck(g+sg,nil,2,REASON_EFFECT)~=0 then
			local og=(Duel.GetOperatedGroup()-sg):Filter(cm.bfilter,nil)
			if #og>0 then
				local ag=Duel.GetFieldGroup(tp,0xff,0xff)+Duel.GetOverlayGroup(tp,1,1)
				local bg=Group.CreateGroup()
				for oc in aux.Next(og) do bg:Merge(ag:Filter(cm.cfilter,nil,oc:GetOriginalCode())) end
				for bc in aux.Next(bg) do
					local ct=bc:GetFlagEffect(m)
					bc:RegisterFlagEffect(m,0,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(m,ct+1))
				end
			end
		end
	end
end