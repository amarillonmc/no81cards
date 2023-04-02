--录型镜·镜中他我
local m=11630206
local cm=_G["c"..m]
function c11630206.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(cm.cost)
	c:RegisterEffect(e1) 
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetDescription(aux.Stringid(m,0))
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetHintTiming(0,TIMING_END_PHASE)
	e2:SetCountLimit(2)
	e2:SetLabelObject(e1)
	e2:SetTarget(cm.sptg)   
	e2:SetOperation(cm.spop)
	c:RegisterEffect(e2)   
end
cm.SetCard_xxj_Mirror=true
function cm.filter(c)
	return c:IsLevelAbove(1) 
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.CheckReleaseGroup(tp,cm.filter,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local rg=Duel.SelectReleaseGroup(tp,cm.filter,1,1,nil)
	local tc=rg:GetFirst()
	Duel.Release(rg,REASON_COST)
	local atk=tc:GetBaseAttack()
	local att=tc:GetOriginalAttribute()
	local race=tc:GetOriginalRace()
	local def=tc:GetBaseDefense()
	local lv=tc:GetOriginalLevel()
	local code=tc:GetCode()
	e:SetLabel(atk,att,race,def,lv,code)
	c:RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD,0,1)
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local atk,att,race,def,lv,code=e:GetLabelObject():GetLabel()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,code,0,TYPES_TOKEN_MONSTER,atk,def,lv,race,att) and e:GetHandler():GetFlagEffect(m)>=1 end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	local atk,att,race,def,lv,code=e:GetLabelObject():GetLabel()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	if e:GetHandler():GetFlagEffect(m)<=0 then return end
	if Duel.IsPlayerCanSpecialSummonMonster(tp,code,0,TYPES_TOKEN_MONSTER,atk,def,lv,race,att) then
		local token=Duel.CreateToken(tp,11630207)		
		--e:GetLabelObject():GetLabel()
		--Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP)		
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EFFECT_CHANGE_ATTRIBUTE)
		e1:SetValue(att)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD)
		token:RegisterEffect(e1,true)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_CHANGE_RACE)
		e2:SetValue(race)
		token:RegisterEffect(e2,true)
		local e3=e1:Clone()
		e3:SetCode(EFFECT_SET_ATTACK_FINAL)
		e3:SetValue(atk)
		token:RegisterEffect(e3,true)
		local e4=e1:Clone()
		e4:SetCode(EFFECT_SET_BASE_DEFENSE_FINAL)
		e4:SetValue(def)
		token:RegisterEffect(e4,true)
		local e5=e1:Clone()
		e5:SetCode(EFFECT_CHANGE_LEVEL)
		e5:SetValue(lv)
		token:RegisterEffect(e5,true)
		local e6=e1:Clone()
		e6:SetCode(EFFECT_CHANGE_CODE)
		e6:SetValue(code)
		token:RegisterEffect(e6,true)
		Duel.SpecialSummonStep(token,0,tp,tp,true,false,POS_FACEUP)
		Duel.BreakEffect()
		Duel.SpecialSummonComplete()
	end
end