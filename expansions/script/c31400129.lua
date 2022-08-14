local m=31400129
local cm=_G["c"..m]
cm.name="王国的魔界王"
function cm.initial_effect(c)
	aux.EnablePendulumAttribute(c)
	aux.EnableReviveLimitPendulumSummonable(c,LOCATION_HAND+LOCATION_PZONE+LOCATION_EXTRA)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetDescription(aux.Stringid(m,0))
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_PZONE)
	e2:SetValue(SUMMON_TYPE_PENDULUM)
	e2:SetCondition(cm.pcon)
	e2:SetOperation(cm.pop)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_BATTLE_DESTROYED)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetTarget(cm.pentg)
	e3:SetOperation(cm.penop)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_DESTROY+CATEGORY_TOHAND+CATEGORY_SEARCH)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	e4:SetCondition(cm.thcon)
	e4:SetTarget(cm.thtg)
	e4:SetOperation(cm.thop)
	c:RegisterEffect(e4)
end
function cm.splimit(e,se,sp,st)
	return bit.band(st,SUMMON_TYPE_PENDULUM)==SUMMON_TYPE_PENDULUM
end
function cm.pcon(e,c)
	if c==nil then return true end
	if c:IsForbidden() then return false end
	local tp=c:GetControler()
	local lsc=Duel.GetFieldCard(tp,LOCATION_PZONE,0)
	local rsc=Duel.GetFieldCard(tp,LOCATION_PZONE,1)
	if lsc==nil or rsc==nil then return false end
	local lscale=lsc:GetLeftScale()
	local rscale=rsc:GetRightScale()
	local lv=c:GetLevel()
	if lscale>rscale then lscale,rscale=rscale,lscale end
	if lv<=lscale or lv>=rscale then return false end
	local loc=false
	if c:IsLocation(LOCATION_EXTRA) then
		loc=Duel.GetLocationCountFromEx(tp,tp,nil,TYPE_PENDULUM)>0
	else
		loc=Duel.GetLocationCount(tp,LOCATION_MZONE)>0
	end
	if not loc then return false end
	local tc=Duel.GetMatchingGroup(nil,tp,LOCATION_PZONE,0,c):GetFirst()
	if c:IsLocation(LOCATION_PZONE) and not (tc:IsAttribute(ATTRIBUTE_DARK) or tc:IsCode(m,31400135,31400136,31400137,31400138)) then return false end
	local canp=false
	local eset={Duel.IsPlayerAffectedByEffect(tp,EFFECT_EXTRA_PENDULUM_SUMMON)}
	local usable_eset={}
	local m=1
	if Auxiliary.PendulumChecklist&(0x1<<tp)==0 then
		canp=true
		m=0
	end
	for _,te in ipairs(eset) do
		local f=te:GetValue()
		if not f or f(te,c,e,tp,lscale,rscale) then
			canp=true
			table.insert(usable_eset,te)
		end
	end
	if canp then
		if #usable_eset>0 then
			e:SetLabel(m)
			e:SetLabelObject(table.unpack(usable_eset))
		else
			e:SetLabel(nil)
			e:SetLabelObject(nil)
		end
		return true
	else
		return false
	end
end
function cm.pop(e,tp,eg,ep,ev,re,r,rp,c)
	local eset={e:GetLabelObject()}
	local ce=nil
	if #eset>0 then
		local options={}
		local m=e:GetLabel()
		if m==0 then
			table.insert(options,1163)
		end
		for _,te in ipairs(eset) do
			table.insert(options,te:GetDescription())
		end
		local op=Duel.SelectOption(tp,table.unpack(options))
		if op+m>0 then
			ce=eset[op+m]
		end
	end
	if ce then
		Duel.Hint(HINT_CARD,0,ce:GetOwner():GetOriginalCode())
		ce:UseCountLimit(tp)
	else
		Auxiliary.PendulumChecklist=Auxiliary.PendulumChecklist|(0x1<<tp)
	end
	Duel.HintSelection(Group.FromCards(Duel.GetFieldCard(tp,LOCATION_PZONE,0)))
	Duel.HintSelection(Group.FromCards(Duel.GetFieldCard(tp,LOCATION_PZONE,1)))
end
function cm.pentg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1) end
end
function cm.penop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToEffect(e) then
		Duel.MoveToField(e:GetHandler(),tp,tp,LOCATION_PZONE,POS_FACEUP,true)
	end
end
function cm.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_PENDULUM)
end
function cm.thfilter(c)
	return c:IsType(TYPE_PENDULUM) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local pg=Duel.GetFieldGroup(tp,LOCATION_PZONE,0)
	if chkc then return false end
	if chk==0 then return #pg>0 and pg:FilterCount(Card.IsCanBeEffectTarget,nil,e)==#pg and Duel.IsExistingMatchingCard(cm.thfilter,tp,LOCATION_DECK,0,#pg,nil) end
	Duel.SetTargetCard(pg)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,pg,pg:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,pg:GetCount(),tp,LOCATION_DECK)
end
function cm.thop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local tg=g:Filter(Card.IsRelateToEffect,nil,e)
	if tg:GetCount()==0 then return end
	Duel.Destroy(tg,REASON_EFFECT)
	local num=tg:FilterCount(function(c) return c:IsLocation(LOCATION_EXTRA) and c:IsPosition(POS_FACEUP) end,nil)
	local sg=Duel.GetMatchingGroup(cm.thfilter,tp,LOCATION_DECK,0,nil)
	if num==0 or #sg<num then return end
	Duel.BreakEffect()
	local thg=sg:Select(tp,num,num,nil)
	Duel.SendtoHand(thg,nil,REASON_EFFECT)
	Duel.ConfirmCards(1-tp,thg)
end