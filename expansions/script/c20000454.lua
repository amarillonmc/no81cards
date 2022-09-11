--渊异术士 冥凝
local cm,m,o=GetID()
if not pcall(function() require("expansions/script/c20000450") end) then require("script/c20000450") end
function cm.initial_effect(c)
	aux.AddCodeList(c,20000455)
	c:EnableReviveLimit()
	cm.Hand_Be_Open = fu_Abyss.Hand_Be_Open(c,m,cm.tg1,cm.op1,CATEGORY_TOHAND+CATEGORY_SEARCH)
--[[
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_UPDATE_LEVEL)
	e2:SetRange(LOCATION_HAND)
	e2:SetTargetRange(LOCATION_HAND,0)
	e2:SetCondition(fu_Abyss.HO_con)
	e2:SetTarget(cm.tg2)
	e2:SetValue(3)
	c:RegisterEffect(e2)
--]]
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetRange(LOCATION_HAND)
	e3:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetCondition(fu_Abyss.HO_con)
	e3:SetTargetRange(1,0)
	e3:SetTarget(cm.tg3)
	c:RegisterEffect(e3)
end
--e1
function cm.tgf1(c,e,tp,eg,ep,ev,re,r,rp)
	if not (c:IsAbleToHand() and c:IsSetCard(0x9fd5) and c:IsType(TYPE_MONSTER) and c:IsRace(RACE_SPELLCASTER) and not c:IsCode(m)) then return end
	local te=c.Hand_Be_Open
	if not te then return false end
	te=te:GetTarget()
	return not te or te and te(e,tp,eg,ep,ev,re,r,rp,0)
end
function cm.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.tgf1,tp,LOCATION_DECK,0,1,nil,e,tp,eg,ep,ev,re,r,rp) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	Duel.Hint(24,0,aux.Stringid(m,0))
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local v=Duel.SelectMatchingCard(tp,cm.tgf1,tp,LOCATION_DECK,0,1,1,nil,e,tp,eg,ep,ev,re,r,rp):GetFirst()
	if v and Duel.SendtoHand(v,nil,REASON_EFFECT)>0 and e:GetHandler():IsRelateToEffect(e) then
		Duel.ConfirmCards(1-tp,v)
		local lv=v:GetLevel()
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_LEVEL)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetValue(lv)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e:GetHandler():RegisterEffect(e1)
		v=v.Hand_Be_Open:GetOperation()
		if v then v(e,tp,eg,ep,ev,re,r,rp) end
	end
end
--e2
function cm.tg2(e,c)
	return c:IsPublic()
end
--e3
function cm.tg3(e,c,sump,sumtype,sumpos,targetp,se)
	return not (c:IsRace(RACE_DRAGON) and c:GetType()&0x81==0x81)
end