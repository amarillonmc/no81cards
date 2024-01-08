--双燃剑舞者 炎
local m=14001561
local cm=_G["c"..m]
cm.named_with_Blazedance=1
function cm.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,cm.matfilter,1,1)
	c:SetSPSummonOnce(m)
	--to hand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetTarget(cm.thtg)
	e1:SetOperation(cm.thop)
	c:RegisterEffect(e1)
	--sp from gy
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,1))
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_BATTLE_DESTROYED)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e2:SetRange(LOCATION_GRAVE)
	--e2:SetCountLimit(1)
	e2:SetCondition(cm.hacon)
	e2:SetTarget(cm.hatg)
	e2:SetOperation(cm.haop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_BATTLE_DAMAGE)
	c:RegisterEffect(e3)
end
function cm.blazed(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_Blazedance
end
cm.loaded_metatable_list=cm.loaded_metatable_list or {}
function cm.load_metatable(code)
	local m1=_G["c"..code]
	if m1 then return m1 end
	local m2=cm.loaded_metatable_list[code]
	if m2 then return m2 end
	_G["c"..code]={}
	if pcall(function() dofile("expansions/script/c"..code..".lua") end) or pcall(function() dofile("script/c"..code..".lua") end) then
		local mt=_G["c"..code]
		_G["c"..code]=nil
		if mt then
			cm.loaded_metatable_list[code]=mt
			return mt
		end
	else
		_G["c"..code]=nil
	end
end
function cm.check_link_set_blazed(c)
	if c:IsLinkType(TYPE_LINK) then return end
	local codet={c:GetLinkCode()}
	for j,code in pairs(codet) do
		local mt=cm.load_metatable(code)
		if mt then
			for str,v in pairs(mt) do
				if type(str)=="string" and str:find("_Blazedance") and v then return true end
			end
		end
	end
	return false
end
function cm.matfilter(c)
	return cm.check_link_set_blazed(c)
end
function cm.thfilter(c)
	return cm.blazed(c) and c:IsAbleToHand() and c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function cm.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,cm.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if #g>0 then
		if Duel.SendtoHand(g,nil,REASON_EFFECT)~=0 and g:GetFirst():IsLocation(LOCATION_HAND) then
			Duel.ConfirmCards(1-tp,g)
			Duel.BreakEffect()
			local ats=c:GetAttackableTarget()
			if Duel.GetCurrentPhase()>=PHASE_BATTLE_START and Duel.GetCurrentPhase()<=PHASE_BATTLE and #ats>0 and Duel.SelectYesNo(tp,aux.Stringid(m,2)) then
				--local ats=c:GetAttackableTarget()
				if not c:IsAttackable() or c:IsImmuneToEffect(e) or ats:GetCount()==0 then
					Duel.Destroy(c,REASON_EFFECT)
					return
				end 
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATTACKTARGET)
				local g=ats:Select(tp,1,1,nil)
				if #g>0 then
					local tc=g:GetFirst()
					local e1=Effect.CreateEffect(c)
					e1:SetType(EFFECT_TYPE_SINGLE)
					e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
					e1:SetValue(1)
					e1:SetReset(RESET_PHASE+PHASE_DAMAGE)
					c:RegisterEffect(e1)
					if tc then
						local e2=Effect.CreateEffect(c)
						e2:SetType(EFFECT_TYPE_SINGLE)
						e2:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
						e2:SetValue(1)
						e2:SetReset(RESET_PHASE+PHASE_DAMAGE)
						tc:RegisterEffect(e2)
					end
					Duel.HintSelection(g)
					Duel.CalculateDamage(c,tc)
				end
			else
				Duel.Destroy(c,REASON_EFFECT)
			end
		end
	end
end
function cm.cfilter(c)
	return c:IsFaceup() and cm.blazed(c)
end
function cm.hacon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()>=PHASE_BATTLE_START and Duel.GetCurrentPhase()<=PHASE_BATTLE and (Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)==0
		or Duel.IsExistingMatchingCard(cm.cfilter,tp,LOCATION_MZONE,0,1,nil))
end
function cm.hatg(e,tp,eg,ep,ev,re,r,rp,chk)
   local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function cm.haop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
end