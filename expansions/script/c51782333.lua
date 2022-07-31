--炎王妃 阿修罗
function c51782333.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(51782333,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetRange(LOCATION_MZONE+LOCATION_HAND)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(TIMING_END_PHASE,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetTarget(c51782333.destg)
	e1:SetOperation(c51782333.desop)
	c:RegisterEffect(e1)
	--reg destroy (deck)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetOperation(c51782333.spr)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(51782333,1))
	e3:SetCategory(CATEGORY_DESTROY+CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e3:SetCondition(c51782333.spcon)
	e3:SetTarget(c51782333.sptg)
	e3:SetOperation(c51782333.spop)
	e3:SetLabelObject(e2)
	c:RegisterEffect(e3)
end
function c51782333.desfilter(c)
	return c:IsSetCard(0x81) and c:IsType(TYPE_MONSTER) and not c:IsCode(51782333)
end
function c51782333.desfilter2(c)
	return c:IsSetCard(0x81) and c:IsType(TYPE_MONSTER)
end
function c51782333.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(c51782333.desfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,c)
		and Duel.IsExistingMatchingCard(c51782333.desfilter2,tp,LOCATION_DECK,0,1,nil) and c:GetFlagEffect(51782333)==0 end
	c:RegisterFlagEffect(51782333,RESET_CHAIN,0,1)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,1,tp,LOCATION_HAND+LOCATION_MZONE)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,1,tp,LOCATION_DECK)
end
function c51782333.geteffect(c)
	cregister=Card.RegisterEffect
	table_effect={}
	Card.RegisterEffect=function(card,effect,flag)
		if effect and ((effect:GetCode()==EVENT_TO_GRAVE and effect:IsHasType(EFFECT_TYPE_TRIGGER_O)) or (effect:GetCode()==EVENT_BATTLE_DESTROYED and effect:IsHasType(EFFECT_TYPE_TRIGGER_O)) or effect:GetCode()==(EVENT_PHASE+PHASE_STANDBY)) then
			local eff=effect:Clone()
			table.insert(table_effect,eff)
		end
		return 
	end
	table_effect={}
	Duel.CreateToken(0,c:GetOriginalCode())
	Card.RegisterEffect=cregister
	return table_effect
end
function c51782333.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectMatchingCard(tp,c51782333.desfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,1,c)
	if #g==0 then return end
	g:AddCard(c)
	if Duel.Destroy(g,REASON_EFFECT)~=0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local g2=Duel.SelectMatchingCard(tp,c51782333.desfilter2,tp,LOCATION_DECK,0,1,1,nil)
		if g2:GetCount()>0 then
			Duel.BreakEffect()
			Duel.Destroy(g2,REASON_EFFECT)
			local tc=g2:GetFirst()
			local Fire_King_table_effect=c51782333.geteffect(tc)
			if #Fire_King_table_effect==1 then
				Duel.Hint(HINT_CARD,0,tc:GetOriginalCode())
				local effect=table.unpack(Fire_King_table_effect)
				local tg=effect:GetTarget()
				local op=effect:GetOperation()
				tc:RegisterEffect(effect)
				tc:CreateEffectRelation(effect)
				if not (not tg or tg(effect,tp,eg,ep,ev,re,r,rp,0)) then return end
				if tg then tg(effect,tp,eg,ep,ev,re,r,rp,1) end
				local ttg=Group.CreateGroup()
				local ttg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
				if ttg then
					local ttg2=ttg:GetFirst()
					while ttg2 do
						ttg2:CreateEffectRelation(effect)
						ttg2=ttg:GetNext()
					end
				end
				if op then op(effect,tp,eg,ep,ev,re,r,rp,1) end
				tc:ReleaseEffectRelation(effect)
				if ttg then
					local ttg2=ttg:GetFirst()
					while ttg2 do
						ttg2:ReleaseEffectRelation(effect)
						ttg2=ttg:GetNext()
					end
				end
				effect:Reset()
				if tc:GetOriginalCode()==69000994 then
					if Duel.GetCurrentPhase()==PHASE_STANDBY then
						tc:RegisterFlagEffect(69000994,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_STANDBY,0,2)
					else
						tc:RegisterFlagEffect(69000994,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_STANDBY,0,1)
					end
				end
			elseif #Fire_King_table_effect==2 then
				Duel.Hint(HINT_CARD,0,tc:GetOriginalCode())
				Duel.ClearTargetCard()
				local effect1,effect2=table.unpack(Fire_King_table_effect)
				local tg1=effect1:GetTarget()
				local tg2=effect2:GetTarget()
				local op=0
				tc:RegisterEffect(effect1)
				tc:CreateEffectRelation(effect1)
				tc:RegisterEffect(effect2)
				tc:CreateEffectRelation(effect2)
				if (not tg1 or tg1(effect1,tp,eg,ep,ev,re,r,rp,0)) and not (not tg2 or tg2(effect2,tp,eg,ep,ev,re,r,rp,0)) then op=Duel.SelectOption(tp,effect1:GetDescription())+1
				elseif (not tg2 or tg2(effect2,tp,eg,ep,ev,re,r,rp,0)) and not (not tg1 or tg1(effect1,tp,eg,ep,ev,re,r,rp,0)) then op=Duel.SelectOption(tp,effect2:GetDescription())+2 
				elseif (not tg1 or tg1(effect1,tp,eg,ep,ev,re,r,rp,0)) and (not tg2 or tg2(effect2,tp,eg,ep,ev,re,r,rp,0)) then op=Duel.SelectOption(tp,effect1:GetDescription(),effect2:GetDescription())+1
				end
				if op==1 then
					local tg=effect1:GetTarget()
					local op=effect1:GetOperation()
					if not (not tg or tg(effect1,tp,eg,ep,ev,re,r,rp,0)) then return end
					if tg then tg(effect1,tp,eg,ep,ev,re,r,rp) end
					local ttg=Group.CreateGroup()
					local ttg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
					if ttg then
						local ttg2=ttg:GetFirst()
						while ttg2 do
							ttg2:CreateEffectRelation(effect1)
							ttg2=ttg:GetNext()
						end
					end
					if op then op(effect1,tp,eg,ep,ev,re,r,rp) end
					if ttg then
						local ttg2=ttg:GetFirst()
						while ttg2 do
							ttg2:ReleaseEffectRelation(effect1)
							ttg2=ttg:GetNext()
						end
					end
				elseif op==2 then
					local tg=effect2:GetTarget()
					local op=effect2:GetOperation()
					if not (not tg or tg(effect2,tp,eg,ep,ev,re,r,rp,0)) then return end
					if tg then tg(effect2,tp,eg,ep,ev,re,r,rp) end
					local ttg=Group.CreateGroup()
					local ttg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
					if ttg then
						local ttg2=ttg:GetFirst()
						while ttg2 do
							ttg2:CreateEffectRelation(effect2)
							ttg2=ttg:GetNext()
						end
					end
					if op then op(effect2,tp,eg,ep,ev,re,r,rp) end
					if ttg then
						local ttg2=ttg:GetFirst()
						while ttg2 do
							ttg2:ReleaseEffectRelation(effect2)
							ttg2=ttg:GetNext()
						end
					end
				end
				tc:ReleaseEffectRelation(effect1)
				effect1:Reset()
				tc:ReleaseEffectRelation(effect2)
				effect2:Reset()
			end
		end
	end
end
function c51782333.spr(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not e:GetHandler():IsReason(REASON_DESTROY) then return end
	if Duel.GetCurrentPhase()==PHASE_STANDBY then
		e:SetLabel(Duel.GetTurnCount())
		c:RegisterFlagEffect(51782333,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_STANDBY+RESET_SELF_TURN,0,2)
	else
		e:SetLabel(0)
		c:RegisterFlagEffect(51782333,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_STANDBY+RESET_SELF_TURN,0,1)
	end
end
function c51782333.spcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return e:GetLabelObject():GetLabel()~=Duel.GetTurnCount() and c:GetFlagEffect(51782333)>0
end
function c51782333.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
	local g=Duel.GetFieldGroup(tp,LOCATION_ONFIELD,LOCATION_ONFIELD)
	if g:GetCount()>0 then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
	end
end
function c51782333.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	if Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0 then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local g=Duel.SelectMatchingCard(tp,nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
		if g:GetCount()>0 then
			Duel.HintSelection(g)
			Duel.Destroy(g,REASON_EFFECT)
		end
	end
end
