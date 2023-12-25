--假面骑士 OOO
function c32100008.initial_effect(c)
	aux.AddCodeList(c,32100002)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcCodeFunRep(c,32100002,aux.FilterBoolFunction(Card.IsFusionCode,32100006),3,3,true,true) 
	--fusion 
	local e0=Effect.CreateEffect(c) 
	e0:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON)
	e0:SetType(EFFECT_TYPE_QUICK_O) 
	e0:SetCode(EVENT_FREE_CHAIN) 
	e0:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e0:SetRange(LOCATION_EXTRA)  
	e0:SetCountLimit(1,12100008)
	e0:SetTarget(c32100008.fsptg)
	e0:SetOperation(c32100008.fspop)
	c:RegisterEffect(e0) 
	local e0=Effect.CreateEffect(c)  
	e0:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS) 
	e0:SetCode(EVENT_SPSUMMON_SUCCESS)   
	e0:SetCondition(function(e) 
	return e:GetHandler():IsSummonType(SUMMON_TYPE_FUSION) end) 
	e0:SetOperation(function(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	c:RegisterFlagEffect(32100008,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(32100006,1))
	c:RegisterFlagEffect(32100008,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(32100006,2))
	c:RegisterFlagEffect(32100008,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(32100006,3)) 
	end)
	c:RegisterEffect(e0) 
	--des 
	local e1=Effect.CreateEffect(c) 
	e1:SetDescription(aux.Stringid(32100008,1)) 
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_IGNITION) 
	e1:SetRange(LOCATION_MZONE) 
	e1:SetCountLimit(1)  
	e1:SetTarget(c32100008.destg)
	e1:SetOperation(c32100008.desop)  
	e1:SetCondition(function(e) 
	return e:GetHandler():IsSummonType(SUMMON_TYPE_FUSION) end)
	c:RegisterEffect(e1)
	--atk  
	local e1=Effect.CreateEffect(c)  
	e1:SetType(EFFECT_TYPE_SINGLE)  
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetRange(LOCATION_MZONE) 
	e1:SetValue(500)   
	e1:SetCondition(function(e) 
	return e:GetHandler():IsSummonType(SUMMON_TYPE_FUSION) end)
	c:RegisterEffect(e1)  
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(32100008,2))
	e1:SetCategory(CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_BATTLE_START)
	e1:SetTarget(c32100008.tgtg)
	e1:SetOperation(c32100008.tgop) 
	e1:SetCondition(function(e) 
	return e:GetHandler():IsSummonType(SUMMON_TYPE_FUSION) end)
	c:RegisterEffect(e1)  
	--indes
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(32100008,3)) 
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_ATTACK_ANNOUNCE)
	e1:SetCountLimit(1)  
	e1:SetTarget(c32100008.drtg)
	e1:SetOperation(c32100008.drop)  
	e1:SetCondition(function(e) 
	return e:GetHandler():IsSummonType(SUMMON_TYPE_FUSION) end)
	c:RegisterEffect(e1) 
	--token
	local e2=Effect.CreateEffect(c) 
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS) 
	e2:SetProperty(EFFECT_FLAG_DELAY) 
	e2:SetCountLimit(1,22100008)
	e2:SetCondition(function(e) 
	return e:GetHandler():IsSummonLocation(LOCATION_EXTRA) end)
	e2:SetTarget(c32100008.tktg)
	e2:SetOperation(c32100008.tkop)
	c:RegisterEffect(e2) 
	--spsummon
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetCountLimit(1,32100008)
	e3:SetCondition(c32100008.spcon)
	e3:SetTarget(c32100008.sptg)
	e3:SetOperation(c32100008.spop)
	c:RegisterEffect(e3)
end 
c32100008.SetCard_HR_Kmr000=true 
function c32100008.filter1(c,e)
	return not c:IsImmuneToEffect(e)
end 
function c32100008.fsptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then 
		local c=e:GetHandler()
		local chkf=tp
		local mg1=Duel.GetFusionMaterial(tp,LOCATION_ONFIELD) 
		local res=c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false) and c:CheckFusionMaterial(mg1,nil,chkf) 
		if not res then
			local ce=Duel.GetChainMaterial(tp)
			if ce~=nil then
				local fgroup=ce:GetTarget()
				local mg2=fgroup(ce,e,tp)
				local mf=ce:GetValue()
				res=c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false) and c:CheckFusionMaterial(mg2,mf,chkf) 
			end
		end 
		return res
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c32100008.fspop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	local chkf=tp
	local mg1=Duel.GetFusionMaterial(tp,LOCATION_ONFIELD):Filter(c32100008.filter1,nil,e) 
	local sg1=nil 
	local mg2=nil
	local sg2=nil
	local ce=Duel.GetChainMaterial(tp)
	if ce~=nil then
		local fgroup=ce:GetTarget()
		mg2=fgroup(ce,e,tp)
		local mf=ce:GetValue() 
	end 
	if c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false) and c:CheckFusionMaterial(mg1,mf,chkf) then 
		if (sg2==nil or not sg2:IsContains(c) or not Duel.SelectYesNo(tp,ce:GetDescription())) then
			local mat1=Duel.SelectFusionMaterial(tp,c,mg1,nil,chkf)
			c:SetMaterial(mat1)
			Duel.SendtoGrave(mat1,REASON_EFFECT+REASON_MATERIAL+REASON_FUSION)
			Duel.BreakEffect()
			Duel.SpecialSummon(c,SUMMON_TYPE_FUSION,tp,tp,false,false,POS_FACEUP)
		else
			local mat2=Duel.SelectFusionMaterial(tp,c,mg2,nil,chkf)
			local fop=ce:GetOperation()
			fop(ce,e,tp,c,mat2)
		end 
		c:CompleteProcedure()
	end 
end
function c32100008.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(function(c) return c:IsFaceup() and c:GetAttack()<1000 end,tp,0,LOCATION_MZONE,nil) 
	if chk==0 then return g:GetCount()>0 end 
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0) 
end
function c32100008.desop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(function(c) return c:IsFaceup() and c:GetAttack()<1000 end,tp,0,LOCATION_MZONE,nil) 
	if g:GetCount()>0 then 
		Duel.Destroy(g,REASON_EFFECT) 
	end 
end 
function c32100008.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local d=Duel.GetAttackTarget()
	if chk==0 then return Duel.GetAttacker()==e:GetHandler() and d and d:IsDefensePos() end 
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,d,1,0,0)
end
function c32100008.tgop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local d=Duel.GetAttackTarget()
	if d:IsRelateToBattle() and d:IsDefensePos() then
		Duel.SendtoGrave(d,REASON_EFFECT) 
	end
end
function c32100008.drtg(e,tp,eg,ep,ev,re,r,rp,chk) 
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end 
	Duel.SetTargetPlayer(tp) 
	Duel.SetTargetParam(1)  
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c32100008.drop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler() 
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT) 
end 
function c32100008.tktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanSpecialSummonMonster(tp,32100009,0,TYPES_TOKEN_MONSTER,2700,2300,8,RACE_WARRIOR,ATTRIBUTE_WIND,POS_FACEUP) and Duel.GetLocationCount(tp,LOCATION_MZONE)>=2 and not Duel.IsPlayerAffectedByEffect(tp,59822133) end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,2,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,2,0,0)
end
function c32100008.tkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then return end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<2 then return end
	if not Duel.IsPlayerCanSpecialSummonMonster(tp,32100009,0,TYPES_TOKEN_MONSTER,2700,2300,8,RACE_WARRIOR,ATTRIBUTE_WIND,POS_FACEUP) then return end
	for i=1,2 do
		local token=Duel.CreateToken(tp,32100009)
		Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP)  
	end
	Duel.SpecialSummonComplete()
end
function c32100008.spcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD)
end
function c32100008.spfilter(c,e,tp)
	return c:IsCode(32100002) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c32100008.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c32100008.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end
function c32100008.spop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c32100008.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end


