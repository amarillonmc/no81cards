--真神 翼神龙-球形体
local m=91020012
local cm=c91020012
function c91020012.initial_effect(c)
	aux.AddCodeList(c,91020014)
	Duel.EnableGlobalFlag(GLOBALFLAG_BRAINWASHING_CHECK)
	--summon with 3 tribute
	local e11=Effect.CreateEffect(c)
	e11:SetDescription(aux.Stringid(m,0))
	e11:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e11:SetType(EFFECT_TYPE_SINGLE)
	e11:SetCode(EFFECT_LIMIT_SUMMON_PROC)
	e11:SetCondition(cm.ttcon1)
	e11:SetOperation(cm.ttop1)
	e11:SetValue(SUMMON_TYPE_ADVANCE)
	c:RegisterEffect(e11)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,1))
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_SPSUM_PARAM)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_LIMIT_SUMMON_PROC)
	e2:SetTargetRange(POS_FACEUP_ATTACK,1)
	e2:SetCondition(cm.ttcon2)
	e2:SetOperation(cm.ttop2)
	e2:SetValue(SUMMON_TYPE_ADVANCE)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_LIMIT_SET_PROC)
	e3:SetCondition(cm.setcon)
	c:RegisterEffect(e3)
	--cannot special summon
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_SPSUMMON_CONDITION)
	e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e4:SetValue(cm.splimit)
	c:RegisterEffect(e4)
	--control return
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e5:SetCode(EVENT_SUMMON_SUCCESS)
	e5:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e5:SetOperation(cm.retreg)
	c:RegisterEffect(e5)
	--cannot be target
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_SINGLE)
	e7:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e7:SetCode(EFFECT_CANNOT_BE_BATTLE_TARGET)
	e7:SetRange(LOCATION_MZONE)
	e7:SetValue(aux.imval1)
	c:RegisterEffect(e7)
	local e8=e7:Clone()
	e8:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e8:SetValue(aux.tgoval)
	c:RegisterEffect(e8)
	--spsummon
	local e9=Effect.CreateEffect(c)
	e9:SetDescription(aux.Stringid(m,2))
	e9:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e9:SetType(EFFECT_TYPE_IGNITION)
	e9:SetRange(LOCATION_MZONE)
	e9:SetCountLimit(2,m*2+EFFECT_COUNT_CODE_DUEL)
	e9:SetCost(cm.spcost)
	e9:SetTarget(cm.sptg)
	e9:SetOperation(cm.spop)
	c:RegisterEffect(e9)
	--SpecialSummon
	local e10=Effect.CreateEffect(c) 
	e10:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e10:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e10:SetCountLimit(1,m+EFFECT_COUNT_CODE_DUEL)
	e10:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e10:SetCode(EVENT_LEAVE_FIELD)
	e10:SetTarget(cm.tg1)
	e10:SetOperation(cm.op1)
	c:RegisterEffect(e10)
--atk\def up 
   local e11=Effect.CreateEffect(c)
	e11:SetType(EFFECT_TYPE_FIELD)
	e11:SetCode(EFFECT_MATERIAL_CHECK)
	e11:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_IGNORE_RANGE)
	e11:SetValue(cm.valcheck)
	e11:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e11,tp)   
	local e12=Effect.CreateEffect(c)
	e12:SetDescription(aux.Stringid(m,3))
	e12:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e12:SetType(EFFECT_TYPE_IGNITION)
	e12:SetRange(LOCATION_MZONE)
	e12:SetCost(cm.spcost2)
	e12:SetTarget(cm.sptg2)
	e12:SetOperation(cm.spop2)
	c:RegisterEffect(e12)
end
function cm.splimit(e,se,sp,st)
local sc=se:GetHandler()
	return sc and sc:IsType(TYPE_MONSTER) and sc:IsCode(91020013)
end
--SpecialSummon
function cm.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
 if chk==0 then return true end
	Duel.SetChainLimit(aux.FALSE)
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
local g1=Duel.CreateToken(tp,91020013)   
local g2=Group.FromCards(g1)
	Duel.SpecialSummon(g2,0,tp,tp,true,true,POS_FACEUP)
end
--atk up
function cm.valcheck(e,c)
		local g=c:GetMaterial()
		local tc=g:GetFirst()
		local atk=0
		local def=0
		while tc do
			atk=atk+math.max(tc:GetTextAttack(),0)
			def=def+math.max(tc:GetTextDefense(),0)
			tc=g:GetNext()
		end
		--atk continuous effect
		local e11=Effect.CreateEffect(c)
		e11:SetType(EFFECT_TYPE_SINGLE)
		e11:SetCode(EFFECT_SET_BASE_ATTACK)
		e11:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE)
		e11:SetCondition(cm.con11)
		e11:SetRange(LOCATION_MZONE)
		e11:SetValue(atk)
		e11:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD)
		c:RegisterEffect(e11)
		--def continuous effect
		local e2=e11:Clone()
		e2:SetCode(EFFECT_SET_BASE_DEFENSE)
		e2:SetValue(def)
		c:RegisterEffect(e2)
  
end
function cm.con11(e,c)
return e:GetHandler():IsCode(91020012)
end
function cm.ttcon1(e,c,minc)
	if c==nil then return true end
	return minc<=3 and Duel.CheckTribute(c,3)
end
function cm.ttop1(e,tp,eg,ep,ev,re,r,rp,c)
	local g=Duel.SelectTribute(tp,c,3,3)
	c:SetMaterial(g)
	Duel.Release(g,REASON_SUMMON+REASON_MATERIAL)
end
function cm.ttcon2(e,c,minc)
	if c==nil then return true end
	local tp=c:GetControler()
	local mg=Duel.GetFieldGroup(tp,0,LOCATION_MZONE)
	return minc<=3 and Duel.CheckTribute(c,3,3,mg,1-tp)
end
function cm.ttop2(e,tp,eg,ep,ev,re,r,rp,c)
	local mg=Duel.GetFieldGroup(tp,0,LOCATION_MZONE)
	local g=Duel.SelectTribute(tp,c,3,3,mg,1-tp)
	c:SetMaterial(g)
	Duel.Release(g,REASON_SUMMON+REASON_MATERIAL)
end
function cm.setcon(e,c,minc)
	if not c then return true end
	return false
end
function cm.retreg(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	c:RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET+RESET_PHASE+PHASE_END,0,2)
	local e11=Effect.CreateEffect(c)
	e11:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e11:SetCode(EVENT_PHASE+PHASE_END)
	e11:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e11:SetLabel(Duel.GetTurnCount()+1)
	e11:SetCountLimit(1)
	e11:SetCondition(cm.retcon)
	e11:SetOperation(cm.retop)
	e11:SetReset(RESET_PHASE+PHASE_END,2)
	Duel.RegisterEffect(e11,tp)
end
function cm.retcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnCount()==e:GetLabel() and e:GetOwner():GetFlagEffect(m)~=0
end
function cm.retop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetOwner()
	local e11=Effect.CreateEffect(e:GetHandler())
	e11:SetType(EFFECT_TYPE_FIELD)
	e11:SetCode(EFFECT_REMOVE_BRAINWASHING)
	e11:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e11:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e11:SetLabelObject(c)
	e11:SetTarget(cm.rettg)
	Duel.RegisterEffect(e11,tp)
	--reset
	local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_ADJUST)
	e2:SetLabelObject(e11)
	e2:SetOperation(cm.reset)
	Duel.RegisterEffect(e2,tp)
end
function cm.rettg(e,c)
	return c==e:GetLabelObject() and c:GetFlagEffect(m)~=0
end
function cm.reset(e,tp,eg,ep,ev,re,r,rp)
	e:GetLabelObject():Reset()
	e:Reset()
end
function cm.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsReleasable() end
	Duel.Release(e:GetHandler(),REASON_COST)
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>-1 end   
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local g1=Duel.CreateToken(tp,91020014)   
	local g=Group.FromCards(g1)
	local tc=g1
	if g1 and Duel.SpecialSummon(g,0,tp,tp,true,true,POS_FACEUP)then
		local e11=Effect.CreateEffect(e:GetHandler())
		e11:SetType(EFFECT_TYPE_SINGLE)
		e11:SetCode(EFFECT_SET_ATTACK)
		e11:SetValue(4000)
		e11:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e11)
		local e2=e11:Clone()
		e2:SetCode(EFFECT_SET_DEFENSE)
		tc:RegisterEffect(e2)
	end
	Duel.SpecialSummonComplete()
end
function cm.spcost2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsReleasable() end
	Duel.Release(e:GetHandler(),REASON_COST)
end
function cm.filter(c,e,tp)
	return (c:IsCode(91020014) or c:IsCode(91020013)) and c:IsCanBeSpecialSummoned(e,0,tp,true,false)
end
function cm.sptg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>-1
		and Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_GRAVE_SPSUMMON,nil,1,tp,LOCATION_GRAVE)
end
function cm.spop2(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,cm.filter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	local tc=g:GetFirst()
	if tc and Duel.SpecialSummonStep(tc,0,tp,tp,true,false,POS_FACEUP) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_ATTACK)
		e1:SetValue(4000)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_SET_DEFENSE)
		tc:RegisterEffect(e2)
	end
	Duel.SpecialSummonComplete()
end