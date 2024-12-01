local m=11223405
local cm=_G["c"..m]
cm.name="血迷"
function cm.initial_effect(c)
	--Effect Gain
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_BE_MATERIAL)
	e1:SetCondition(cm.efcon)
	e1:SetOperation(cm.efop)
	c:RegisterEffect(e1)
	--Special Summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_DESTROYED)
	e2:SetCountLimit(1,m)
	e2:SetCondition(cm.condition)
	e2:SetTarget(cm.target)
	e2:SetOperation(cm.operation)
	c:RegisterEffect(e2)
end
--Effect Gain
function cm.efcon(e,tp,eg,ep,ev,re,r,rp)
	return r==REASON_FUSION or r==REASON_SYNCHRO or r==REASON_XYZ
end
function cm.efop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rc=c:GetReasonCard()
	if rc:GetBaseAttack()~=500 or rc:GetBaseDefense()~=500 or rc:GetFlagEffect(m)~=0 then return end
	--Indes
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(1)
	e1:SetReset(RESET_EVENT+0x1fe0000)
	rc:RegisterEffect(e1,true)
	--To Grave
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOGRAVE)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_DESTROYED)
	e2:SetRange(LOCATION_MZONE)
	e2:SetReset(RESET_EVENT+0x1fe0000)
	e2:SetCondition(cm.tgcon)
	e2:SetOperation(cm.tgop)
	rc:RegisterEffect(e2)
	if not rc:IsType(TYPE_EFFECT) then
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_SINGLE)
		e3:SetCode(EFFECT_ADD_TYPE)
		e3:SetValue(TYPE_EFFECT)
		e3:SetReset(RESET_EVENT+0x1fe0000)
		rc:RegisterEffect(e3,true)
	end
	rc:RegisterFlagEffect(m,RESET_EVENT+0x1fe0000,0,1)
	rc:RegisterFlagEffect(0,RESET_EVENT+0x1fe0000,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(m,0))
end
function cm.tgfilter(c,tp)
	return c:IsReason(REASON_BATTLE+REASON_EFFECT) and c:IsPreviousLocation(LOCATION_ONFIELD)
end
function cm.tgcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(cm.tgfilter,1,nil)
end
function cm.tgop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,m)
	Duel.DiscardDeck(tp,1,REASON_EFFECT)
end
--Special Summon
function cm.condition(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsReason(REASON_EFFECT)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false) then
		local ct=Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
		local mg=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_MZONE,0,c)
		if ct~=0 and Duel.IsExistingMatchingCard(cm.check,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg,c)
			and Duel.SelectYesNo(tp,aux.Stringid(m,2)) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local tc=Duel.SelectMatchingCard(tp,cm.check,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,mg,c):GetFirst()
			if tc then
				Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(m,3))
				local mt=Duel.SelectMatchingCard(tp,cm.mtfilter,tp,LOCATION_MZONE,0,1,1,nil,tp,tc,c,e)
				mt:AddCard(c)
				if tc:IsType(TYPE_FUSION) then
					tc:SetMaterial(mt)
					Duel.SendtoGrave(mt,REASON_EFFECT+REASON_MATERIAL+REASON_FUSION)
					Duel.BreakEffect()
					Duel.SpecialSummon(tc,SUMMON_TYPE_FUSION,tp,tp,false,false,POS_FACEUP)
				elseif tc:IsType(TYPE_SYNCHRO) then
					tc:SetMaterial(mt)
					Duel.SendtoGrave(mt,REASON_EFFECT+REASON_MATERIAL+REASON_SYNCHRO)
					Duel.BreakEffect()
					Duel.SpecialSummon(tc,SUMMON_TYPE_SYNCHRO,tp,tp,false,false,POS_FACEUP)
					tc:CompleteProcedure()
				elseif tc:IsType(TYPE_XYZ) then
					Duel.XyzSummon(tp,tc,mt)
				end
			end
		end
	end
end
function cm.check(c,e,tp,mg,mt)
	return cm.fusioncheck(c,e,tp,mg,mt) or cm.synchrocheck(c,e,tp,mg,mt) or cm.xyzcheck(c,e,tp,mg,mt)
end
function cm.mtfilter(c,tp,tc,mt,e)
	return cm.ffilter(c,tp,tc,mt,e) or cm.sfilter(c,tp,tc,mt) or cm.xfilter(c,tp,tc,mt)
end
--Fusion
function cm.fusioncheck(c,e,tp,mg,mt)
	return c:IsType(TYPE_FUSION) and c:GetAttack()==500 and c:GetDefense()==500
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false)
		and mg:IsExists(cm.ffilter,1,nil,tp,c,mt,e)
end
function cm.ffilter(c,tp,tc,mt,e)
	local sg=Group.FromCards(c,mt)
	return not c:IsImmuneToEffect(e) and tc:CheckFusionMaterial(sg,mt,tp)
end
--Synchro
function cm.synchrocheck(c,e,tp,mg,mt)
	return c:GetAttack()==500 and c:GetDefense()==500 and mg:IsExists(cm.sfilter,1,nil,tp,c,mt)
end
function cm.sfilter(c,tp,tc,mt)
	local sg=Group.FromCards(c,mt)
	return tc:IsSynchroSummonable(nil,sg)
end
--Xyz
function cm.xyzcheck(c,e,tp,mg,mt)
	return c:GetAttack()==500 and c:GetDefense()==500 and mg:IsExists(cm.xfilter,1,nil,tp,c,mt)
end
function cm.xfilter(c,tp,tc,mt)
	local sg=Group.FromCards(c,mt)
	return tc:IsXyzSummonable(sg,2,2)
end
