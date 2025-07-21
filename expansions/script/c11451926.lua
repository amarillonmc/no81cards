--芭斯瓦尔德的祝诞
local cm,m=GetID()
function cm.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_FLAG_EFFECT+m)
	e2:SetRange(LOCATION_FZONE+LOCATION_GRAVE)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetTargetRange(1,0)
	e2:SetCondition(cm.con)
	c:RegisterEffect(e2)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_CUSTOM+m)
	e4:SetRange(LOCATION_FZONE+LOCATION_GRAVE)
	--e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetOperation(cm.op)
	c:RegisterEffect(e4)
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
	--c:RegisterEffect(e3)	
end
function cm.con(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(cm.tgfilter,tp,LOCATION_GRAVE,0,nil)
	return not c:IsLocation(LOCATION_GRAVE) or (g:IsContains(c) and #g>=3)
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	--[[if cm[c]~=1 then
		if cm[c]==2 then cm[c]=nil return end
		local eset={Duel.IsPlayerAffectedByEffect(tp,EFFECT_FLAG_EFFECT+m)}
		local g=Group.CreateGroup()
		for _,te in pairs(eset) do g:AddCard(te:GetHandler()) end
		if #g>1 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
			g=g:Select(tp,1,1,nil)
		end
		local tc=g:GetFirst()
		if tc~=c then
			g:RemoveCard(c)
			for rc in aux.Next(g) do cm[rc]=2 end
			cm[tc]=1
			cm[c]=nil
			return
		else
			for rc in aux.Next(g) do cm[rc]=2 end
			cm[c]=nil
		end
	end--]]
	if not c:IsLocation(LOCATION_GRAVE) then
		Duel.SendtoGrave(c,REASON_EFFECT)
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		local sg=Duel.GetMatchingGroup(cm.tgfilter,tp,LOCATION_GRAVE,0,nil)
		local tg=sg:SelectSubGroup(tp,cm.fselect2,false,3,sg:GetClassCount(Card.GetCode),c)
		Duel.SendtoDeck(tg,nil,2,REASON_EFFECT)
	end
end
function cm.tgfilter(c,e)
	return c:IsSetCard(0x97b) and c:IsAbleToDeck() and (not e or c:IsCanBeEffectTarget(e))
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
function cm.fselect2(g,c)
	return g:GetClassCount(Card.GetCode)==#g and (not c or g:IsContains(c))
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