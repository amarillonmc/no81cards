--幸福之魔法少女
local m=43990101
local cm=_G["c"..m]
function cm.initial_effect(c)
	aux.EnableChangeCode(c,43990028,LOCATION_MZONE)
	--xyz summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsRace,RACE_SPELLCASTER),8,2,nil,nil,99)
	c:EnableReviveLimit()
	local e0=Effect.CreateEffect(c)
	e0:SetDescription(aux.Stringid(43990101,0))
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetCode(EFFECT_SPSUMMON_PROC)
	e0:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e0:SetRange(LOCATION_EXTRA)
	e0:SetCondition(c43990101.xyzcondition)
	e0:SetTarget(c43990101.xyztarget)
	e0:SetOperation(c43990101.XyzOperation)
	e0:SetValue(SUMMON_TYPE_XYZ)
	c:RegisterEffect(e0)
	--splimit
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c43990101.regcon)
	e1:SetOperation(c43990101.regop)
	c:RegisterEffect(e1)
	--SpecialSummon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(43990101,1))
	e2:SetCategory(CATEGORY_RECOVER)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,43990101)
	e2:SetCondition(c43990101.spcon)
	e2:SetCost(c43990101.spcost)
	e2:SetTarget(c43990101.sptg)
	e2:SetOperation(c43990101.spop)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(43990101,1))
	e3:SetCategory(CATEGORY_RECOVER)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_CAL)
	e3:SetCode(Damage)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,43990101)
	e3:SetCondition(c43990101.spcon2)
	e3:SetCost(c43990101.spcost)
	e3:SetTarget(c43990101.sptg)
	e3:SetOperation(c43990101.spop)
	c:RegisterEffect(e3)
	--Destroy
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_DESTROY+CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e4:SetCode(EVENT_PHASE+PHASE_END)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1,43991101)
	e4:SetCondition(c43990101.dscon)
	e4:SetTarget(c43990101.dstg)
	e4:SetOperation(c43990101.dsop)
	c:RegisterEffect(e4)
	if not c43990101.global_check then
		c43990101.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_DAMAGE)
		ge1:SetOperation(c43990101.checkop)
		Duel.RegisterEffect(ge1,0)
	end
end
function c43990101.checkop(e,tp,eg,ep,ev,re,r,rp)
	local flag=Duel.GetFlagEffectLabel(tp,43990101)
	if flag then
		Duel.SetFlagEffectLabel(tp,43990101,flag+ev)
	else
		Duel.RegisterFlagEffect(tp,43990101,RESET_PHASE+PHASE_END,0,1,ev)
	end
end
function c43990101.xyzfilter1(c)
	return c:IsRace(RACE_SPELLCASTER) and c:IsLevel(8)
end
function c43990101.xyzcondition(e,c,og,min,max)
	if c==nil then return true end
	local tp=c:GetControler()
	local mg
	if og then
		mg=og
	else
		mg=Duel.GetFieldGroup(tp,LOCATION_GRAVE,0)
	end
	return mg:IsExists(c43990101.xyzfilter1,2,nil) and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0 and Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil)
end
function c43990101.xyztarget(e,tp,eg,ep,ev,re,r,rp,chk,c,og,min,max)
	local mg=nil
	local mg2=nil
	local g=nil
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
	if og then
		mg=og 
	else
		mg=Duel.GetMatchingGroup(c43990101.xyzfilter1,tp,LOCATION_GRAVE,0,nil)
		g=mg:Select(tp,2,2,nil)
	end
	if g then
		g:KeepAlive()
		e:SetLabelObject(g)
		return true
	else return false end
end
function c43990101.XyzOperation(e,tp,eg,ep,ev,re,r,rp,c,og,min,max)
	local mg=nil
	if og then
		mg=og
	else
		mg=e:GetLabelObject()
	local sg=Group.CreateGroup()
	local tc=mg:GetFirst()
	while tc do
		local sg1=tc:GetOverlayGroup()
		sg:Merge(sg1)
		tc=mg:GetNext()
		end
	Duel.SendtoGrave(sg,REASON_RULE)
	end
	c:SetMaterial(mg)
	Duel.Overlay(c,mg)
	mg:DeleteGroup()
end
function c43990101.regcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_XYZ)
end
function c43990101.regop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetTargetRange(1,0)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTarget(c43990101.splimit)
	Duel.RegisterEffect(e1,tp)
end
function c43990101.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return c:IsCode(43990101) and bit.band(sumtype,SUMMON_TYPE_XYZ)==SUMMON_TYPE_XYZ
end
function c43990101.spcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_XYZ)
end
function c43990101.spcon2(e,tp,eg,ep,ev,re,r,rp)
	return ep==tp
end
function c43990101.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c43990101.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,PLAYER_ALL,2000)
end
function c43990101.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Recover(tp,2000,REASON_EFFECT)
	Duel.Recover(1-tp,2000,REASON_EFFECT)
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_MZONE,0,nil) 
	if g:GetCount()>0 then 
		local tc=g:GetFirst() 
		while tc do 
		local e1=Effect.CreateEffect(c)
		e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
		e1:SetType(EFFECT_TYPE_SINGLE) 
		e1:SetRange(LOCATION_MZONE)
		e1:SetCode(EFFECT_INDESTRUCTABLE_COUNT)
		e1:SetValue(1) 
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END+RESET_OPPO_TURN)
		tc:RegisterEffect(e1)
		tc=g:GetNext() 
		end 
	end  
end
function c43990101.dscon(e,tp,eg,ep,ev,re,r,rp)
	local flag=Duel.GetFlagEffectLabel(tp,43990101)
	return flag and Duel.GetFlagEffectLabel(tp,43990101)>=4000
end
function c43990101.dstg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,e:GetHandler(),1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,0,1,tp,LOCATION_HAND+LOCATION_DECK)
end
function c43990101.sssfilter(c,e,tp)
	return c:IsRace(RACE_SPELLCASTER) and c:IsAttribute(ATTRIBUTE_LIGHT) and c:IsLevel(8) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c43990101.dsop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToEffect(e) then Duel.Destroy(e:GetHandler(),REASON_EFFECT) end 
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(c43990101.sssfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil,e,tp) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,c43990101.sssfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,1,nil,e,tp)
		local tc=g:GetFirst()
		if tc and Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP) then
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_CHANGE_ATTRIBUTE)
			e1:SetValue(ATTRIBUTE_DARK)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e1,true)
		end
		Duel.SpecialSummonComplete()
	end
end