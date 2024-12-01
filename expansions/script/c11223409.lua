local m=11223409
local cm=_G["c"..m]
cm.name="血傲子"
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
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_DESTROYED)
	e2:SetRange(LOCATION_HAND)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e2:SetCountLimit(1,m)
	e2:SetCondition(cm.condition)
	e2:SetTarget(cm.target)
	e2:SetOperation(cm.operation)
	c:RegisterEffect(e2)
end
--Effect Gain
function cm.efcon(e,tp,eg,ep,ev,re,r,rp)
	return r==REASON_RITUAL or r==REASON_LINK
end
function cm.efop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if r==REASON_RITUAL then
		local rc=eg:GetFirst()
		while rc do
			regeff(c,rc,rp)
			rc=eg:GetNext()
		end
	else
		local rc=c:GetReasonCard()
		regeff(c,rc,rp)
	end
end
function regeff(c,tc,tp)
	if tc:GetBaseAttack()==500 and tc:GetFlagEffect(m)==0 then
		local e1=Effect.CreateEffect(c)
		e1:SetDescription(aux.Stringid(m,0))
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
		e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CLIENT_HINT)
		e1:SetRange(LOCATION_MZONE)
		e1:SetLabel(tp)
		e1:SetValue(cm.tgval)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e1,true)
		tc:RegisterFlagEffect(m,RESET_EVENT+0x1fe0000,0,1)
		--To Grave
		local e2=Effect.CreateEffect(c)
		e2:SetCategory(CATEGORY_RECOVER+CATEGORY_DAMAGE)
		e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e2:SetCode(EVENT_REMOVE)
		e2:SetRange(LOCATION_MZONE)
		e2:SetReset(RESET_EVENT+0x1fe0000)
		e2:SetOperation(cm.rmop)
		tc:RegisterEffect(e2)
		if not tc:IsType(TYPE_EFFECT) then
			local e3=Effect.CreateEffect(c)
			e3:SetType(EFFECT_TYPE_SINGLE)
			e3:SetCode(EFFECT_ADD_TYPE)
			e3:SetValue(TYPE_EFFECT)
			e3:SetReset(RESET_EVENT+0x1fe0000)
			tc:RegisterEffect(e3,true)
		end
	end
end
function cm.tgval(e,re,rp)
	return rp==1-e:GetLabel()
end
function cm.rmop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,m)
	Duel.Recover(tp,300,REASON_EFFECT,true)
	Duel.Damage(1-tp,300,REASON_EFFECT,true)
	Duel.RDComplete()
end
--Special Summon
function cm.filter(c)
	return c:GetBaseAttack()==500 and c:IsReason(REASON_BATTLE+REASON_EFFECT)
end
function cm.condition(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(cm.filter,1,nil)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false) 
		and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0 then
		local mg=Duel.GetRitualMaterial(tp)
		local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
		local ritual=Duel.IsExistingMatchingCard(cm.ritualcheck,tp,LOCATION_HAND,0,1,nil,e,tp,mg,ft)
		local link=Duel.IsExistingMatchingCard(cm.linkcheck,tp,LOCATION_EXTRA,0,1,nil)
		if ritual and Duel.SelectYesNo(tp,aux.Stringid(m,2)) then
			local mg=Duel.GetRitualMaterial(tp)
			local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local tg=Duel.SelectMatchingCard(tp,cm.ritualcheck,tp,LOCATION_HAND,0,1,1,nil,e,tp,mg,ft)
			local tc=tg:GetFirst()
			if tc then
				mg=mg:Filter(Card.IsCanBeRitualMaterial,tc,tc)
				if tc.ritual_custom_operation then
					tc:ritual_custom_operation(mg)
					local mat=tc:GetMaterial()
					Duel.ReleaseRitualMaterial(mat)
				else
					if tc.mat_filter then
						mg=mg:Filter(tc.mat_filter,nil)
					end
					local mat=nil
					if ft>0 then
						Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
						mat=mg:SelectWithSumEqual(tp,Card.GetRitualLevel,tc:GetLevel(),1,99,tc)
					else
						Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
						mat=mg:FilterSelect(tp,cm.mfilterf,1,1,nil,tp,mg,tc)
						Duel.SetSelectedCard(mat)
						Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
						local mat2=mg:SelectWithSumEqual(tp,Card.GetRitualLevel,tc:GetLevel(),0,99,tc)
						mat:Merge(mat2)
					end
					tc:SetMaterial(mat)
					Duel.ReleaseRitualMaterial(mat)
				end
				Duel.BreakEffect()
				Duel.SpecialSummon(tc,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP)
				tc:CompleteProcedure()
			end
		elseif link and Duel.SelectYesNo(tp,aux.Stringid(m,3)) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local g=Duel.SelectMatchingCard(tp,cm.linkcheck,tp,LOCATION_EXTRA,0,1,1,nil)
			Duel.SpecialSummonRule(tp,g:GetFirst(),SUMMON_TYPE_LINK)
		end
	end
end
--Ritual
function cm.ritualcheck(c,e,tp,m,ft)
	if not c:IsType(TYPE_RITUAL) or not c:IsType(TYPE_MONSTER)
		or not c:GetBaseAttack()==500 or not c:GetLevel()==8
		or not c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,false,true) then return false end
	local mg=m:Filter(Card.IsCanBeRitualMaterial,c,c)
	if c.ritual_custom_condition then return c:ritual_custom_condition(mg,ft) end
	if c.mat_filter then
		mg=mg:Filter(c.mat_filter,nil)
	end
	if ft>0 then
		return mg:CheckWithSumEqual(Card.GetRitualLevel,c:GetLevel(),1,99,c)
	else
		return ft>-1 and mg:IsExists(cm.mfilterf,1,nil,tp,mg,c)
	end
end
function cm.mfilterf(c,tp,mg,rc)
	if c:IsControler(tp) and c:IsLocation(LOCATION_MZONE) and c:GetSequence()<5 then
		Duel.SetSelectedCard(c)
		return mg:CheckWithSumEqual(Card.GetRitualLevel,rc:GetLevel(),0,99,rc)
	else return false end
end
--Link
function cm.linkcheck(c)
	return c:GetAttack()==500 and c:IsSpecialSummonable(SUMMON_TYPE_LINK)
end