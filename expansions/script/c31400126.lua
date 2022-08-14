local m=31400126
local cm=_G["c"..m]
cm.name="隐熊极天-左辅"
function cm.getlink_level(c)
	local e1=c:IsHasEffect(EFFECT_CHANGE_LEVEL_FINAL)
	if e1 then
		local value=e1:GetValue()
		if type(value)=='Effect' then
			return value(e1,c)
		end
		return value
	end
	local lvl=c:GetLink()
	local e2=c:IsHasEffect(EFFECT_CHANGE_LEVEL)
	if e2 then
		local value=e2:GetValue()
		if type(value)=='Effect' then
			lvl=value(e2,c)
		else
			lvl=value
		end
	end
	local eset={c:IsHasEffect(EFFECT_UPDATE_LEVEL)}
	for _,te in pairs(eset) do
		local value=te:GetValue()
		if type(value)=='Effect' then
			lvl=lvl+value(te,c)
		else
			lvl=lvl+value
		end
	end
	return lvl
end
if not cm.hack then
	cm.hack=true
	cm.getlevel=Card.GetLevel
	cm.islevel=Card.IsLevel
	cm.islevela=Card.IsLevelAbove
	cm.islevelb=Card.IsLevelBelow
	cm.islevelx=Card.IsXyzLevel
	Card.GetLevel=function (c)
		if c:GetOriginalCodeRule()==m then
			return cm.getlink_level(c)
		end
		return cm.getlevel(c)
	end
	Card.IsLevel=function(c,...)
		local expara={...}
		if c:GetOriginalCodeRule()==m then
			local lvl=cm.getlink_level(c)
			for _,i in pairs(expara) do
				if i==lvl then return true end
			end
			return false
		end
		return cm.islevel(c,table.unpack(expara))
	end
	Card.IsLevelAbove=function(c,tglv)
		if c:GetOriginalCodeRule()==m then
			return cm.getlink_level(c)>=tglv
		end
		return cm.islevela(c,tglv)
	end
	Card.IsLevelBelow=function(c,tglv)
		if c:GetOriginalCodeRule()==m then
			return cm.getlink_level(c)<=tglv
		end
		return cm.islevelb(c,tglv)
	end
end
function cm.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,cm.linkfilter,1,1)
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_MATERIAL_CHECK)
	e0:SetValue(cm.matcheck)
	c:RegisterEffect(e0)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,m)
	e1:SetCondition(cm.thcon)
	e1:SetTarget(cm.thtg)
	e1:SetOperation(cm.thop)
	e1:SetLabelObject(e0)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,m)
	e2:SetCondition(cm.spcon)
	e2:SetTarget(cm.sptg)
	e2:SetOperation(cm.spop)
	c:RegisterEffect(e2)
end
function cm.linkfilter(c)
	return c:IsSetCard(0x163) and not c:IsType(TYPE_SYNCHRO)
end
function cm.matcheck(e,c)
	e:SetLabel(nil)
	local tc=c:GetMaterial():GetFirst()
	if tc then e:SetLabel(tc:GetLevel()) end
end
function cm.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function cm.thfilter(c,lv)
	return not c:IsLevel(lv) and c:IsSetCard(0x163) and c:IsAbleToHand()
end
function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local lv=e:GetLabelObject():GetLabel()
	if chk==0 then return lv and Duel.IsExistingMatchingCard(cm.thfilter,tp,LOCATION_DECK,0,1,nil,lv) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function cm.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,cm.thfilter,tp,LOCATION_DECK,0,1,1,nil,e:GetLabelObject():GetLabel())
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function cm.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==1-tp
end
function cm.spfilter(c,e,tp)
	return c:IsSetCard(0x163) and c:IsType(TYPE_TUNER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(cm.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,cm.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end