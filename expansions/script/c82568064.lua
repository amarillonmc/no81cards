--泰拉的行军·REUNION
function c82568064.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c82568064.target)
	e1:SetOperation(c82568064.activate)
	c:RegisterEffect(e1)
	--add code
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e4:SetCode(EFFECT_ADD_CODE)
	e4:SetValue(82567785)
	c:RegisterEffect(e4)
end
function c82568064.filter(c,e,tp)
	return c:IsCode(82567899) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,true,true)
end
function c82568064.filter2(c)
	return c:IsSummonType(SUMMON_TYPE_FUSION) and c:IsSetCard(0x825) and c:IsReleasable()
end
function c82568064.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return
   Duel.IsExistingMatchingCard(c82568064.filter,tp,LOCATION_EXTRA,0,1,nil,e,tp)
	and  Duel.IsExistingMatchingCard(c82568064.filter2,tp,LOCATION_MZONE,0,3,nil)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c82568064.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(82568064,1))
	local tg=Duel.SelectMatchingCard(tp,c82568064.filter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
	local tc=tg:GetFirst()
	if tc then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
		local mat=Duel.SelectMatchingCard(tp,c82568064.filter2,tp,LOCATION_MZONE,0,3,3,nil)
		if not mat or mat:GetCount()==0 then return end
		tc:SetMaterial(mat)
		Duel.ReleaseRitualMaterial(mat)
		Duel.BreakEffect()
		Duel.SpecialSummon(tc,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP)
		tc:CompleteProcedure()
		e:SetLabelObject(tc)
		local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	e1:SetValue(c82568064.efilter)
	e1:SetCondition(c82568064.iefcon)
	tc:RegisterEffect(e1)
	 local e3=Effect.CreateEffect(e:GetHandler())
	e3:SetDescription(aux.Stringid(82568064,2))
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetTarget(c82568064.distg2)
	e3:SetOperation(c82568064.disop2)
	e3:SetReset(RESET_EVENT+RESETS_STANDARD)
	tc:RegisterEffect(e3)  
	tc:RegisterFlagEffect(0,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(82568064,0))
	end
end
function c82568064.efilter(e,te)
	return te:GetOwnerPlayer()~=e:GetHandlerPlayer() and te:GetOwner()~=e:GetOwner()
		and te:IsActiveType(TYPE_TRAP+TYPE_SPELL+TYPE_MONSTER)
end
function c82568064.iefcon(e)
	return Duel.GetTurnPlayer()~=tp
end
function c82568064.disfilter(c)
	return c:IsFaceup() 
end
function c82568064.distg2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and chkc:IsFaceup() end
	if chk==0 then return Duel.IsExistingTarget(c82568064.disfilter,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SELECT)
	local g=Duel.SelectTarget(tp,c82568064.disfilter,tp,0,LOCATION_MZONE,1,1,nil)
end
function c82568064.disop2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local tc=g:GetFirst()
	if  tc:IsRelateToEffect(e) and c:IsRelateToEffect(e) then 
	 local e5=Effect.CreateEffect(e:GetHandler())
		e5:SetType(EFFECT_TYPE_SINGLE)
		e5:SetCode(EFFECT_CANNOT_BE_FUSION_MATERIAL)
		e5:SetProperty(EFFECT_CANNOT_DISABLE)
		e5:SetValue(RESET_TURN_SET)
		e5:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e5)
		local e6=Effect.CreateEffect(e:GetHandler())
		e6:SetType(EFFECT_TYPE_SINGLE)
		e6:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
		e6:SetProperty(EFFECT_CANNOT_DISABLE)
		e6:SetValue(RESET_TURN_SET)
		e6:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e6)
		local e10=Effect.CreateEffect(e:GetHandler())
		e10:SetType(EFFECT_TYPE_SINGLE)
		e10:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
		e10:SetProperty(EFFECT_CANNOT_DISABLE)
		e10:SetValue(RESET_TURN_SET)
		e10:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e10)
		 local e8=Effect.CreateEffect(e:GetHandler())
		e8:SetType(EFFECT_TYPE_SINGLE)
		e8:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
		e8:SetReset(RESET_EVENT+RESETS_STANDARD)
		e8:SetProperty(EFFECT_CANNOT_DISABLE)
		e8:SetValue(RESET_TURN_SET)
		tc:RegisterEffect(e8)
		local e9=Effect.CreateEffect(e:GetHandler())
		e9:SetType(EFFECT_TYPE_SINGLE)
		e9:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_CANNOT_DISABLE)
		e9:SetReset(RESET_EVENT+RESETS_STANDARD)
		e9:SetRange(LOCATION_MZONE)
		e9:SetCode(EFFECT_UNRELEASABLE_SUM)
		e9:SetValue(1)
		tc:RegisterEffect(e9)
		local e11=e9:Clone()
		e11:SetCode(EFFECT_UNRELEASABLE_NONSUM)
		tc:RegisterEffect(e11)
	end
end