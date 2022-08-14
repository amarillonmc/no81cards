local m=31400136
local cm=_G["c"..m]
cm.name="王国的霸者"
function cm.initial_effect(c)
	c:EnableReviveLimit()
	aux.EnablePendulumAttribute(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetDescription(aux.Stringid(m,0))
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_HAND+LOCATION_EXTRA+LOCATION_PZONE)
	e2:SetValue(SUMMON_TYPE_PENDULUM)
	e2:SetCondition(cm.pcon)
	e2:SetOperation(cm.pop)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_LEAVE_FIELD)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCondition(cm.lfcon)
	e3:SetOperation(cm.lfop)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetRange(LOCATION_MZONE)
	e4:SetTargetRange(0,LOCATION_MZONE)
	e4:SetCode(EFFECT_CANNOT_SELECT_BATTLE_TARGET)
	c:RegisterEffect(e4)
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e5:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_SET_AVAILABLE)
	e5:SetRange(LOCATION_MZONE)
	e5:SetTargetRange(LOCATION_ONFIELD,LOCATION_ONFIELD)
	e5:SetValue(aux.tgoval)
	c:RegisterEffect(e5)
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
	if c:IsLocation(LOCATION_PZONE) and not Duel.GetMatchingGroup(nil,tp,LOCATION_PZONE,0,c):GetFirst():IsAttribute(ATTRIBUTE_EARTH) then return false end
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
function cm.lfcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousLocation(LOCATION_MZONE) and c:IsPreviousControler(tp) and c:GetReasonPlayer()==1-tp and bit.band(c:GetReason(),REASON_BATTLE)==0
end
function cm.lffilter(c,e,tp)
	return c:IsAttribute(ATTRIBUTE_EARTH) and c:IsCanBeSpecialSummoned(e,0,tp,true,false) and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0
end
function cm.lftg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.lffilter,tp,LOCATION_EXTRA,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function cm.lfop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,cm.lffilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,true,false,POS_FACEUP)
	end
end
function cm.damop(e,tp,eg,ep,ev,re,r,rp)
	if rp==1-tp and re:IsActiveType(TYPE_MONSTER) then
		Duel.Hint(HINT_CARD,0,m)
		Duel.SetLP(1-tp,Duel.GetLP(1-tp)-re:GetHandler():GetAttack()/2)
	end
end