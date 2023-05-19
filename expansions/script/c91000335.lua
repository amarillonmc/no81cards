--古战士烈火
function c91000335.initial_effect(c)
	c:EnableReviveLimit()
	--ritual summon
	local e1=aux.AddRitualProcGreater2(c,c91000335.filter,nil,nil,c91000335.matfilter,true) 
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,91000335)
	e1:SetCondition(function(e,tp,eg,ep,ev,re,r,rp)
	return (Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2)
	and Duel.GetFieldGroupCount(e:GetHandlerPlayer(),LOCATION_EXTRA,0)==0 end) 
	c:RegisterEffect(e1)   
	--ritual summon
	local e2=Effect.CreateEffect(c) 
	e2:SetCategory(CATEGORY_RELEASE+CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O) 
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCountLimit(2,91335)
	e2:SetCondition(function(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_RITUAL)
	and Duel.GetFieldGroupCount(e:GetHandlerPlayer(),LOCATION_EXTRA,0)==0 end)  
	e2:SetTarget(c91000335.rstg)
	e2:SetOperation(c91000335.rsop)
	c:RegisterEffect(e2) 

	--disable
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_ATTACK_ANNOUNCE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e3:SetCondition(c91000335.discon)
	e3:SetOperation(c91000335.disop)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EVENT_BE_BATTLE_TARGET)
	c:RegisterEffect(e4)
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_FIELD)
	e6:SetCode(EFFECT_DISABLE)
	e6:SetRange(LOCATION_MZONE)
	e6:SetTargetRange(0,LOCATION_MZONE)
	e6:SetTarget(c91000335.distg)
	c:RegisterEffect(e6)
	local e7=e6:Clone()
	e7:SetCode(EFFECT_DISABLE_EFFECT)
	c:RegisterEffect(e7)

	local e4=Effect.CreateEffect(c) 
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON) 
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O) 
	e4:SetCode(EVENT_RELEASE) 
	e4:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET) 
	e4:SetCountLimit(1,29100335) 
	e4:SetCondition(function(e) 
	return Duel.GetFieldGroupCount(e:GetHandlerPlayer(),LOCATION_EXTRA,0)==0 end)  
	e4:SetOperation(c91000335.riop) 
	c:RegisterEffect(e4)
	local e7=Effect.CreateEffect(c)
	e7:SetDescription(aux.Stringid(1945387,0))
	e7:SetCategory(CATEGORY_DRAW)
	e7:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e7:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e7:SetCode(EVENT_BATTLE_DESTROYED)
	e7:SetRange(LOCATION_MZONE)
	
	e7:SetCondition(c91000335.drcon)
	e7:SetTarget(c91000335.drtg)
	e7:SetOperation(c91000335.drop)
	c:RegisterEffect(e7)
	--special summon cost
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e0:SetCode(EFFECT_SPSUMMON_COST)
	e0:SetCost(c91000335.spccost)
	e0:SetOperation(c91000335.spcop)
	c:RegisterEffect(e0)   
	if not c91000335.global_check then
		c91000335.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_CHAINING)
		ge1:SetOperation(c91000335.checkop)
		Duel.RegisterEffect(ge1,0)
	end 
end
c91000335.material_setcode=0x8
function c91000335.cfilter(c,tp)
	return  c:IsPreviousLocation(LOCATION_MZONE) 
end
function c91000335.drcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c91000335.cfilter,1,nil,tp)
end
function c91000335.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,id)==0 end
	Duel.RegisterFlagEffect(tp,id,RESET_CHAIN,0,1)
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c91000335.drop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end

c91000335.SetCard_Dr_AcWarrior=true 
function c91000335.checkop(e,tp,eg,ep,ev,re,r,rp) 
	if re:IsHasType(EFFECT_TYPE_ACTIVATE) then 
		Duel.RegisterFlagEffect(rp,91000335,RESET_PHASE+PHASE_END,0,0)  
	end  
end
function c91000335.spccost(e,c,tp)
	return Duel.GetFlagEffect(tp,91000335)==0 
end
function c91000335.spcop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	--activate limit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCode(EFFECT_CANNOT_ACTIVATE) 
	e2:SetTargetRange(1,0)
	 e2:SetReset(RESET_PHASE+PHASE_END)
	e2:SetValue(c91000335.actlimit)
	Duel.RegisterEffect(e2,tp) 
end
function c91000335.actlimit(e,re,tp)
	return re:IsHasType(EFFECT_TYPE_ACTIVATE) 
end
function c91000335.filter(c,e,tp,chk)
	return c:IsLevel(10) and c:IsType(TYPE_RITUAL) 
end
function c91000335.matfilter(c,e,tp,chk)
	return not chk or true 
end
function c91000335.xrfilter(c,e,tp,chk)
	return c:IsLevel(10) and c:IsType(TYPE_RITUAL) 
end 
function c91000335.cfilters(c,tp)
	return c:IsControler(tp)
end
function c91000335.discon(e,tp,eg,ep,ev,re,r,rp)
	local c=Duel.GetAttackTarget()
	if not c then return false end
	if c:IsControler(1-tp) then c=Duel.GetAttacker() end
	return c and c91000335.cfilters(c,tp)
end
function c91000335.disop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetAttackTarget()
	if tc:IsControler(tp) then tc=Duel.GetAttacker() end
	tc:RegisterFlagEffect(91000335,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_BATTLE,0,1)
	Duel.AdjustInstantly(c)
end
function c91000335.distg(e,c)
	return c:GetFlagEffect(91000335)~=0
end 
function c91000335.thtg(e,tp,eg,ep,ev,re,r,rp,chk) 
	local x=Duel.GetMatchingGroupCount(function(c) return c:IsFaceup() and c:IsLevel(10) end,tp,LOCATION_MZONE,0,nil) 
	if chk==0 then return x>0 and Duel.IsExistingTarget(Card.IsAbleToHand,tp,LOCATION_ONFIELD+LOCATION_GRAVE,LOCATION_ONFIELD+LOCATION_GRAVE,1,nil) end 
	local g=Duel.SelectTarget(tp,Card.IsAbleToHand,tp,LOCATION_ONFIELD+LOCATION_GRAVE,LOCATION_ONFIELD+LOCATION_GRAVE,1,x,nil) 
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,g:GetCount(),0,0) 
end 
function c91000335.thop(e,tp,eg,ep,ev,re,r,rp)  
	local c=e:GetHandler()
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if g:GetCount()>0 then 
		Duel.SendtoHand(g,nil,REASON_EFFECT)	
	end 
end 
function c91000335.rstg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		local mg=Duel.GetRitualMaterial(tp) 
		local res=Duel.IsExistingMatchingCard(aux.RitualUltimateFilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil,function(c) return c:IsLevel(10) and c:IsType(TYPE_RITUAL) end,e,tp,mg,nil,Card.GetLevel,"Greater") 
		return res
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function c91000335.rsop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local mg=Duel.GetRitualMaterial(tp)
	if c:IsControler(1-tp)  then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON) 
	local tg=Duel.SelectMatchingCard(tp,aux.RitualUltimateFilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil,function(c) return c:IsLevel(10) and c:IsType(TYPE_RITUAL) end,e,tp,mg,nil,Card.GetLevel,"Greater")
	local tc=tg:GetFirst()
	if tc then
		mg=mg:Filter(Card.IsCanBeRitualMaterial,tc,tc)
		if tc.mat_filter then
			mg=mg:Filter(tc.mat_filter,tc,tp)
		else
		mg:RemoveCard(tc)
		end 
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE) 
		local mat=mg:SelectSubGroup(tp,aux.RitualCheck,false,1,tc:GetLevel(),tp,tc,tc:GetLevel(),"Greater") 
		if not mat or mat:GetCount()==0 then 
			return
		end
		tc:SetMaterial(mat)
		Duel.ReleaseRitualMaterial(mat)
		Duel.BreakEffect()
		Duel.SpecialSummon(tc,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP)
		tc:CompleteProcedure()
	end 
end
function c91000335.discon1(e,tp,eg,ep,ev,re,r,rp)
	local ec=Duel.GetAttacker()
	return ec and ec:IsControler(tp) and ec:GetBattleTarget() and ec:GetBattleTarget():IsControler(1-tp) 
end
function c91000335.disop1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetAttacker():GetBattleTarget()
	tc:RegisterFlagEffect(91000335,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_BATTLE,0,1)
	Duel.AdjustInstantly(c)
end
function c91000335.riop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD) 
	e3:SetRange(LOCATION_MZONE) 
	e3:SetTargetRange(LOCATION_MZONE,0) 
	e3:SetTarget(function(e,c) 
	return c:IsLevel(10) end)
	e3:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e3:SetValue(1)
	e3:SetReset(RESET_PHASE+PHASE_END,2) 
	Duel.RegisterEffect(e3,tp)
	local e4=e3:Clone()
	e4:SetCode(EFFECT_CANNOT_REMOVE)
	Duel.RegisterEffect(e4,tp)
end