--罗德岛·医疗干员-凯尔希
function c79029463.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	c:EnableReviveLimit()
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND+LOCATION_PZONE)
	e1:SetCondition(c79029463.spcon)
	e1:SetOperation(c79029463.spop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_CANNOT_DISABLE_SPSUMMON)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	c:RegisterEffect(e2)
	--cannot special summon
	local e3=Effect.CreateEffect(c)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e3)  
	--SpecialSummon
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetTarget(c79029463.spmtg)
	e4:SetOperation(c79029463.spmop)
	c:RegisterEffect(e4) 
	--move
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_QUICK_O)
	e5:SetCode(EVENT_FREE_CHAIN)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCountLimit(1)
	e5:SetTarget(c79029463.mvtg)
	e5:SetOperation(c79029463.mvop)
	c:RegisterEffect(e5)
	--to grave
	local e6=Effect.CreateEffect(c)
	e6:SetCategory(CATEGORY_TOGRAVE)
	e6:SetType(EFFECT_TYPE_IGNITION)
	e6:SetRange(LOCATION_PZONE)
	e6:SetCountLimit(1,79029463)
	e6:SetTarget(c79029463.tgtg)
	e6:SetOperation(c79029463.tgop)
	c:RegisterEffect(e6)
end
c79029463.spchecks=aux.CreateChecks(Card.IsType,{TYPE_RITUAL,TYPE_FUSION,TYPE_SYNCHRO,TYPE_XYZ,TYPE_PENDULUM,TYPE_LINK})
function c79029463.spcostfilter(c)
	return c:IsAbleToRemoveAsCost() and c:IsType(TYPE_RITUAL+TYPE_FUSION+TYPE_SYNCHRO+TYPE_XYZ+TYPE_PENDULUM+TYPE_LINK) and c:IsSetCard(0xa900)
end
function c79029463.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local g=Duel.GetMatchingGroup(c79029463.spcostfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,nil)
	return g:CheckSubGroupEach(c79029463.spchecks,aux.mzctcheck,tp)
end
function c79029463.spop(e,tp,eg,ep,ev,re,r,rp,c)
	Debug.Message("博士，我出现在这里，说明局势不容乐观。你需要专心......继续完成你的使命。")
	Duel.Hint(HINT_SOUND,0,aux.Stringid(79029463,2))
	local g=Duel.GetMatchingGroup(c79029463.spcostfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local sg=g:SelectSubGroupEach(tp,c79029463.spchecks,false,aux.mzctcheck,tp)
	Duel.Remove(sg,POS_FACEUP,REASON_COST)
end
function c79029463.spmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
	Duel.SetChainLimit(aux.FALSE)
end
function c79029463.m3fil(c,e,tp)
	return c:IsCode(79029464) and c:IsCanBeSpecialSummoned(e,0,tp,true,false) and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0
end
function c79029463.spmop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c79029463.m3fil,tp,LOCATION_EXTRA,0,nil,e,tp)
	if g:GetCount()<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tc=g:Select(tp,1,1,nil):GetFirst()
	Debug.Message("Mon3tr，跟着我。")
	Duel.Hint(HINT_SOUND,0,aux.Stringid(79029463,3))
	Duel.SpecialSummon(tc,0,tp,tp,true,false,POS_FACEUP)
	tc:CompleteProcedure()
end
function c79029463.mvfilter1(c)
	return c:IsFaceup() and c:IsCode(79029464)
end
function c79029463.mvtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local b1=Duel.GetMZoneCount(tp)>0
	local b2=Duel.IsExistingMatchingCard(c79029463.mvfilter1,tp,LOCATION_MZONE,0,1,e:GetHandler())
	if chk==0 then return b1 or b2 end
	local op=0
	if b1 and b2 then
	op=Duel.SelectOption(tp,aux.Stringid(79029463,0),aux.Stringid(79029463,1)) 
	elseif b1 then 
	op=Duel.SelectOption(tp,aux.Stringid(79029463,0)) 
	elseif b2 then 
	op=Duel.SelectOption(tp,aux.Stringid(79029463,1)) 
	end
	e:SetLabel(op)
end  
function c79029463.mvop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local op=e:GetLabel()
	if op==0 then 
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOZONE)
	local s=Duel.SelectDisableField(tp,1,LOCATION_MZONE,0,0)
	local nseq=math.log(s,2)
	Debug.Message("到达指定位置了。")
	Duel.Hint(HINT_SOUND,0,aux.Stringid(79029463,4))
	Duel.MoveSequence(c,nseq)   
	else
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONTROL)
	local tc=Duel.SelectMatchingCard(tp,c79029463.mvfilter1,tp,LOCATION_MZONE,0,1,1,e:GetHandler()):GetFirst()
	Debug.Message("现在你只需要安心制定行动计划。")
	Duel.Hint(HINT_SOUND,0,aux.Stringid(79029463,5))
	Duel.SwapSequence(c,tc)   
	end
end
function c79029463.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c79029463.tgfil,tp,LOCATION_EXTRA,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_EXTRA)
end
function c79029463.tgop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c79029463.tgfil,tp,LOCATION_EXTRA,0,nil)
	if g:GetCount()<=0 then return end
	local tc=g:Select(tp,1,1,nil):GetFirst()
	if Duel.SendtoGrave(tc,REASON_EFFECT) then
	local flag=0
	if tc:IsType(TYPE_RITUAL) then flag=bit.bor(flag,TYPE_RITUAL) end
	if tc:IsType(TYPE_FUSION) then flag=bit.bor(flag,TYPE_FUSION) end
	if tc:IsType(TYPE_SYNCHRO) then flag=bit.bor(flag,TYPE_SYNCHRO) end
	if tc:IsType(TYPE_XYZ) then flag=bit.bor(flag,TYPE_XYZ) end
	if tc:IsType(TYPE_PENDULUM) then flag=bit.bor(flag,TYPE_PENDULUM) end
	if tc:IsType(TYPE_LINK) then flag=bit.bor(flag,TYPE_LINK) end
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_CANNOT_SUMMON)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetTargetRange(1,0)
		e1:SetTarget(c79029463.sumlimit)
		e1:SetLabel(flag)
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
		Duel.RegisterEffect(e2,tp)
		local e3=e1:Clone()
		e3:SetCode(EFFECT_CANNOT_MSET)
		Duel.RegisterEffect(e3,tp)
		local e4=e1:Clone()
		e4:SetCode(EFFECT_CANNOT_ACTIVATE)
		e4:SetValue(c79029463.aclimit)
		Duel.RegisterEffect(e4,tp)
	end
end
function c79029463.sumlimit(e,c)
	return c:IsType(e:GetLabel())
end
function c79029463.aclimit(e,re,tp)
	return re:GetHandler():IsType(e:GetLabel()) and re:IsActiveType(TYPE_MONSTER)
end








