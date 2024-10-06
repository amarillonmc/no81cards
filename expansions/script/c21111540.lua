--捕食植物 腐日葵
function c21111540.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddFusionProcFunRep(c,c21111540.mat,2,true)
	aux.AddContactFusionProcedure(c,c21111540.c,LOCATION_MZONE,LOCATION_MZONE,Duel.SendtoDeck,nil,2,REASON_COST)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON+CATEGORY_REMOVE+CATEGORY_GRAVE_ACTION)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS) 
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,21111540)
	e1:SetCondition(c21111540.con)
	e1:SetTarget(c21111540.tg)
	e1:SetOperation(c21111540.op)
	c:RegisterEffect(e1)	
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCategory(CATEGORY_CONTROL+CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,21111541)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_CAL+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_CARD_TARGET)
	e2:SetHintTiming(0,TIMING_END_PHASE+TIMINGS_CHECK_MONSTER+TIMING_DAMAGE_CAL)
	e2:SetTarget(c21111540.tg2)
	e2:SetOperation(c21111540.op2)
	c:RegisterEffect(e2)	
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_DESTROY+CATEGORY_COUNTER)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_CONTROL_CHANGED)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,21111542)
	e3:SetTarget(c21111540.tg3)
	e3:SetOperation(c21111540.op3)
	c:RegisterEffect(e3)
end
function c21111540.mat(c)
	return c:IsType(TYPE_FUSION) and c:IsSetCard(0x10f3) and c:IsLevel(7)
end
function c21111540.c(c,fc)
	return c:IsAbleToExtraAsCost() and c:IsControler(fc:GetControler()) 
end
function c21111540.con(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonLocation(LOCATION_EXTRA)
end
function c21111540.f0(c,e)
	return c:IsAbleToRemove() and not c:IsImmuneToEffect(e) and c:IsAttribute(ATTRIBUTE_DARK) and c:IsRace(RACE_PLANT)
end
function c21111540.f1(c,e,tp,m,f,chkf)
	return c:IsType(TYPE_FUSION) and c:IsAttribute(ATTRIBUTE_DARK) and c:IsRace(RACE_PLANT) and (not f or f(c))
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false) and c:CheckFusionMaterial(m,nil,chkf)
end
function c21111540.gf(c,e)
	return c:IsType(TYPE_MONSTER) and c:IsCanBeFusionMaterial() and c21111540.f0(c,e)
end
function c21111540.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local chkf=tp
		local mg1=Duel.GetMatchingGroup(c21111540.gf,tp,LOCATION_GRAVE,0,nil,e)
		local res=Duel.IsExistingMatchingCard(c21111540.f1,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg1,nil,chkf)
		if not res then
			local ce=Duel.GetChainMaterial(tp)
			if ce~=nil then
				local fgroup=ce:GetTarget()
				local mg2=fgroup(ce,e,tp)
				local mf=ce:GetValue()
				res=Duel.IsExistingMatchingCard(c21111540.f1,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg2,mf,chkf)
			end
		end
		return res
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_GRAVE)
end
function c21111540.op(e,tp,eg,ep,ev,re,r,rp)
	local chkf=tp
	local mg1=Duel.GetMatchingGroup(c21111540.gf,tp,LOCATION_GRAVE,0,nil,e)
	local sg1=Duel.GetMatchingGroup(c21111540.f1,tp,LOCATION_EXTRA,0,nil,e,tp,mg1,nil,chkf)
	local mg2=nil
	local sg2=nil
	local ce=Duel.GetChainMaterial(tp)
	if ce~=nil then
		local fgroup=ce:GetTarget()
		mg2=fgroup(ce,e,tp)
		local mf=ce:GetValue()
		sg2=Duel.GetMatchingGroup(c21111540.f1,tp,LOCATION_EXTRA,0,nil,e,tp,mg2,mf,chkf)
	end
	if #sg1>0 or (sg2~=nil and #sg2>0) then
		local sg=sg1:Clone()
		if sg2 then sg:Merge(sg2) end
		::cancel::
		Duel.Hint(3,tp,HINTMSG_SPSUMMON)
		local tc=sg:Select(tp,1,1,nil):GetFirst()
		if sg1:IsContains(tc) and (sg2==nil or not sg2:IsContains(tc) or not Duel.SelectYesNo(tp,ce:GetDescription())) then
			local mat=Duel.SelectFusionMaterial(tp,tc,mg1,nil,chkf)
			if #mat<2 then goto cancel end
			tc:SetMaterial(mat)
			Duel.Remove(mat,POS_FACEUP,REASON_EFFECT+REASON_MATERIAL+REASON_FUSION)
			Duel.BreakEffect()
			Duel.SpecialSummon(tc,SUMMON_TYPE_FUSION,tp,tp,false,false,POS_FACEUP)
		else
			local mat=Duel.SelectFusionMaterial(tp,tc,mg2,nil,chkf)
			if #mat<2 then goto cancel end
			local fop=ce:GetOperation()
			fop(ce,e,tp,tc,mat)
		end
		tc:CompleteProcedure()
	end
end
function c21111540.j(c,fc)
	return c:IsFaceup() and c:IsSetCard(0x10f3)
end
function c21111540.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsControlerCanBeChanged() and Duel.IsExistingTarget(c21111540.j,tp,LOCATION_MZONE,0,1,c) end
	Duel.Hint(3,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,c21111540.j,tp,LOCATION_MZONE,0,1,1,c)
	Duel.SetOperationInfo(0,CATEGORY_ATKCHANGE,g,1,0,1500)
	Duel.SetOperationInfo(0,CATEGORY_CONTROL,c,1,0,0)
end
function c21111540.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and Duel.GetControl(c,1-tp) and tc:IsFaceup() and tc:IsRelateToEffect(e) then
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetValue(1500)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	tc:RegisterEffect(e1)
	end
end
function c21111540.tg3(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return true end
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_MZONE,nil)
	if #g>0 then
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,1,0,0)
	end
	local cg=Duel.GetMatchingGroup(Card.IsCanAddCounter,tp,0,LOCATION_MZONE,nil,0x1041,1)
	if #g>0 then
	Duel.SetOperationInfo(0,CATEGORY_COUNTER,cg,#cg,0,0)
	end
end
function c21111540.op3(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_MZONE,nil)
	if #g>0 then
	local tg=g:GetMaxGroup(Card.GetAttack)
	local s=0
		if #tg>1 then
			Duel.Hint(3,tp,HINTMSG_DESTROY)
			local sg=tg:Select(1-tp,1,1,nil)
			Duel.HintSelection(sg)
			s=Duel.Destroy(sg,REASON_EFFECT)
		else
			Duel.HintSelection(tg)
			s=Duel.Destroy(tg,REASON_EFFECT) 
		end
		local cg=Duel.GetMatchingGroup(Card.IsCanAddCounter,tp,0,LOCATION_MZONE,nil,0x1041,1)
		if s>0 and #cg>0 then
			for tc in aux.Next(cg) do
			tc:AddCounter(0x1041,1)
				if tc:IsLevelAbove(2) then
				local e1=Effect.CreateEffect(c)
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_CHANGE_LEVEL)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD)
				e1:SetCondition(c21111540.lvcon)
				e1:SetValue(1)
				tc:RegisterEffect(e1)
				end
			end				
		end
	end
end
function c21111540.lvcon(e)
	return e:GetHandler():GetCounter(0x1041)>0
end