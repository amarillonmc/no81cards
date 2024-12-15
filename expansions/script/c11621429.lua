--桃源乡的钓鱼人
local m=11621429
local cm=_G["c"..m]
function cm.initial_effect(c)
	aux.AddCodeList(c,11621403)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
	--ntr
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,1))
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetHintTiming(0,TIMING_END_PHASE+TIMINGS_CHECK_MONSTER)
	e2:SetCountLimit(1,m)
	e2:SetCondition(cm.ntrcon)
	e2:SetTarget(cm.ntrtg)
	e2:SetOperation(cm.ntrop)
	c:RegisterEffect(e2)
	--tohand
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,2))
	e3:SetCategory(CATEGORY_RELEASE)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_RELEASE)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e3:SetCountLimit(1,m+1)
	e3:SetTarget(cm.retg)
	e3:SetOperation(cm.reop)
	c:RegisterEffect(e3)  
	cm[c]=e3	
end
--
function cm.sumlimit(e,c)
	return not c:IsRace(RACE_ZOMBIE)
end
--
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,m,0,TYPES_EFFECT_TRAP_MONSTER,1800,1300,3,RACE_ZOMBIE,ATTRIBUTE_LIGHT) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function cm.posfilter(c)
	return c:IsFaceup()
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0
		or not Duel.IsPlayerCanSpecialSummonMonster(tp,m,0,TYPES_EFFECT_TRAP_MONSTER,1800,1300,3,RACE_ZOMBIE,ATTRIBUTE_LIGHT) then return end
	c:AddMonsterAttribute(TYPE_EFFECT+TYPE_TRAP)
	Duel.SpecialSummon(c,SUMMON_VALUE_SELF,tp,tp,true,false,POS_FACEUP)
end
--02
function cm.ntrfilter(c)
	return c:IsSetCard(0x5220) and c:IsFaceup() and c:IsType(TYPE_RITUAL) and c:IsType(TYPE_MONSTER)
end
function cm.ntrcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_SPECIAL+SUMMON_VALUE_SELF and Duel.IsExistingMatchingCard(cm.ntrfilter,tp,LOCATION_MZONE,0,1,nil)
end
function cm.ntrtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetFieldGroupCount(tp,0,LOCATION_DECK)>=2 and c:IsSSetable() and Duel.IsPlayerCanRelease(tp) end
end
function cm.refilter(c,tp)
	local re=Duel.IsPlayerAffectedByEffect(tp,EFFECT_CANNOT_RELEASE)
	local val=nil
	if re then
		val=re:GetValue()
	end
	return  val==nil or val(re,c)~=true
end
function cm.ntrop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetDecktopGroup(1-tp,2)
	if c:IsRelateToEffect(e) and c:IsSSetable() then
		if Duel.SSet(tp,c)>0 and g:GetCount()==2 then
			Duel.SendtoHand(g,tp,REASON_EFFECT) 
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
			local rg=Duel.SelectMatchingCard(tp,cm.refilter,tp,LOCATION_HAND,0,1,1,nil,tp)
			if rg:GetCount()>0 then		  
				if Duel.Release(rg,REASON_EFFECT)<1 then
					Duel.Release(rg,REASON_COST)
				end
			end
			local tc=Duel.GetOperatedGroup():GetFirst()
			if tc:IsType(TYPE_MONSTER) then
				local code=tc:GetOriginalCodeRule()
				local e1=Effect.CreateEffect(c)
				e1:SetType(EFFECT_TYPE_FIELD)
				e1:SetCode(EFFECT_CHANGE_CODE)
				e1:SetTargetRange(0,0x7f)
				e1:SetTarget(cm.crtg)
				e1:SetLabel(code)
				e1:SetValue(11621403)
				e1:SetReset(RESET_PHASE+PHASE_END)
				Duel.RegisterEffect(e1,tp)
				--
				local e2=Effect.CreateEffect(c)
				e2:SetType(EFFECT_TYPE_FIELD)
				e2:SetCode(EFFECT_CHANGE_RACE)
				e2:SetTargetRange(0,0x7f)
				e2:SetTarget(cm.crtg)
				e2:SetLabel(code)
				e2:SetValue(RACE_ZOMBIE)
				e2:SetReset(RESET_PHASE+PHASE_END)
				Duel.RegisterEffect(e2,tp)
				--
				local e3=Effect.CreateEffect(c)
				e3:SetType(EFFECT_TYPE_FIELD)
				e3:SetCode(EFFECT_CHANGE_ATTRIBUTE)
				e3:SetTargetRange(0,0x7f)
				e3:SetTarget(cm.crtg)
				e3:SetLabel(code)
				e3:SetValue(ATTRIBUTE_LIGHT)
				e3:SetReset(RESET_PHASE+PHASE_END)
				Duel.RegisterEffect(e3,tp)
				--
				local e4=Effect.CreateEffect(c)
				e4:SetType(EFFECT_TYPE_FIELD)
				if tc:IsLevelAbove(1) then
					e4:SetCode(EFFECT_CHANGE_LEVEL)
				end
				if tc:IsRankAbove(1) then
					e4:SetCode(EFFECT_CHANGE_RANK)
				end
				if tc:IsLinkAbove(1) then
					e4:SetCode(EFFECT_UPDATE_LINK)
				end
				e4:SetTargetRange(0,0x7f)
				e4:SetTarget(cm.crtg2)
				e4:SetLabel(code)
				e4:SetValue(3)
				e4:SetReset(RESET_PHASE+PHASE_END)
				Duel.RegisterEffect(e4,tp)
			end
		end
	end
end
function cm.crtg(e,c)
	local code=e:GetLabel()
	return c:IsOriginalCodeRule(code)--c:IsCode(code)
end
function cm.crtg2(e,c)
	local code=e:GetLabel()
	return c:IsOriginalCodeRule(code) and c:IsLevelAbove(1)
end
--03
function cm.retg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_RELEASE,nil,1,0,0)
end
function cm.reop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local g=Duel.SelectMatchingCard(tp,aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,0,1,1,nil)
	Duel.Release(g,REASON_EFFECT)
end