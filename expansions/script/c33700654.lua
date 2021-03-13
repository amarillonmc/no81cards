if not pcall(function() require("expansions/script/c33700650") end) then require("script/c33700650") end
--破天神狐 贰贰〇〇·六五九零八五八二
local m=33700654
local cm=_G["c"..m]
cm.named_with_ptsh=true
function cm.initial_effect(c)
	local e1=sr_ptsh.Cmeffect(c,m)
	
	local e2=sr_ptsh.efeffect(c,m,CATEGORY_SPECIAL_SUMMON+CATEGORY_DISABLE,EVENT_CUSTOM+m,EFFECT_FLAG_DELAY)
	if not cm.global_check then
		cm.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_CHAIN_NEGATED)
		ge1:SetOperation(cm.checkop)
		Duel.RegisterEffect(ge1,0)
	end

	local e3=sr_ptsh.opeffect(c,m)
end
function cm.checkop(e,tp,eg,ep,ev,re,r,rp)
	local dp=Duel.GetChainInfo(ev,CHAININFO_DISABLE_PLAYER)
	Duel.RaiseEvent(e:GetHandler(),EVENT_CUSTOM+m,e,0,dp,0,0)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.IsExistingMatchingCard(aux.disfilter1,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(aux.disfilter1,tp,0,LOCATION_ONFIELD,nil)
	local tc=g:GetFirst()
	if not tc then return end
	local c=e:GetHandler()
	while tc do
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_STANDBY,2)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_STANDBY,2)
		tc:RegisterEffect(e2)
		if tc:IsType(TYPE_TRAPMONSTER) then
			local e3=Effect.CreateEffect(c)
			e3:SetType(EFFECT_TYPE_SINGLE)
			e3:SetCode(EFFECT_DISABLE_TRAPMONSTER)
			e3:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_STANDBY,2)
			tc:RegisterEffect(e3)
		end
		tc=g:GetNext()
	end
	if not c:IsRelateToEffect(e) then return end
	Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
end
function cm.condition(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-tp
end
function cm.geteffect(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	--atk up
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TEMP_REMOVE-RESET_TURN_SET)
	e2:SetValue(800)
	c:RegisterEffect(e2)
	--atk down
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(0,LOCATION_MZONE)
	e2:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TEMP_REMOVE-RESET_TURN_SET)
	e2:SetValue(-800)
	c:RegisterEffect(e2)
end