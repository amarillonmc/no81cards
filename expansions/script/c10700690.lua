--孽驱君主 路西法
function c10700690.initial_effect(c)
	c:EnableReviveLimit()
	aux.EnablePendulumAttribute(c)
	--ritual summon activate
	local e0=Effect.CreateEffect(c)
	e0:SetDescription(aux.Stringid(10700690,0))
	e0:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e0:SetType(EFFECT_TYPE_IGNITION)
	e0:SetRange(LOCATION_PZONE)
	e0:SetCost(c10700690.cost)
	e0:SetTarget(c10700690.target)
	e0:SetOperation(c10700690.activate)
	c:RegisterEffect(e0)	
	--immune
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetCondition(c10700690.immcon)
	e1:SetValue(c10700690.efilter)
	c:RegisterEffect(e1)  
	--damage
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetOperation(c10700690.regop)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_CHAIN_SOLVED)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(c10700690.damcon)
	e3:SetOperation(c10700690.damop)
	c:RegisterEffect(e3)
	--negate
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(10700690,2))
	e4:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_CHAINING)
	e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1,10700690)
	e4:SetCondition(c10700690.negcon)
	e4:SetTarget(c10700690.negtg)
	e4:SetOperation(c10700690.negop)
	c:RegisterEffect(e4)
end
function c10700690.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToExtra() end
	Duel.SendtoExtraP(e:GetHandler(),nil,REASON_COST)
end
function c10700690.dfilter(c)
	return c:IsFaceup() and c:IsAbleToGrave() and c:IsLevelAbove(1) 
end
function c10700690.filter(c,e,tp)
	return c:IsRace(RACE_FIEND) or c:IsAttribute(ATTRIBUTE_DARK)
end
function c10700690.rcheck(tp,g,c)
	return g:FilterCount(Card.IsLocation,nil,LOCATION_EXTRA)<=99
end
function c10700690.rgcheck(g)
	return g:FilterCount(Card.IsLocation,nil,LOCATION_EXTRA)<=99
end
function c10700690.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local mg=Duel.GetRitualMaterial(tp)
		local dg=Duel.GetMatchingGroup(c10700690.dfilter,tp,LOCATION_EXTRA,0,nil)
		aux.RCheckAdditional=c10700673.rcheck
		aux.RGCheckAdditional=c10700673.rgcheck
		local res=Duel.IsExistingMatchingCard(aux.RitualUltimateFilter,tp,LOCATION_HAND+LOCATION_EXTRA,0,1,nil,c10700690.filter,e,tp,mg,dg,Card.GetLevel,"Greater")
		aux.RCheckAdditional=nil
		aux.RGCheckAdditional=nil
		return res
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_EXTRA)
end
function c10700690.activate(e,tp,eg,ep,ev,re,r,rp)
	local m=Duel.GetRitualMaterial(tp)
	local dg=Duel.GetMatchingGroup(c10700690.dfilter,tp,LOCATION_EXTRA,0,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	aux.RCheckAdditional=c10700690.rcheck
	aux.RGCheckAdditional=c10700690.rgcheck
	local tg=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(aux.RitualUltimateFilter),tp,LOCATION_HAND+LOCATION_EXTRA,0,1,1,nil,c10700690.filter,e,tp,m,dg,Card.GetLevel,"Greater")
	local tc=tg:GetFirst()
	if tc then
		local mg=m:Filter(Card.IsCanBeRitualMaterial,tc,tc)
		mg:Merge(dg)
		if tc.mat_filter then
			mg=mg:Filter(tc.mat_filter,tc,tp)
		else
			mg:RemoveCard(tc)
		end
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(10700686,1))
		aux.GCheckAdditional=aux.RitualCheckAdditional(tc,tc:GetLevel(),"Greater")
		local mat=mg:SelectSubGroup(tp,aux.RitualCheck,false,1,tc:GetLevel(),tp,tc,tc:GetLevel(),"Greater")
		aux.GCheckAdditional=nil
		if not mat or mat:GetCount()==0 then
			aux.RCheckAdditional=nil
			aux.RGCheckAdditional=nil
			return
		end
		tc:SetMaterial(mat)
		local dmat=mat:Filter(Card.IsLocation,nil,LOCATION_EXTRA)
		if dmat:GetCount()>0 then
			mat:Sub(dmat)
			Duel.SendtoGrave(dmat,REASON_EFFECT+REASON_MATERIAL+REASON_RITUAL)
		end
		if mat:GetCount()>0 then
			Duel.ReleaseRitualMaterial(mat)
		end
		Duel.BreakEffect()
		Duel.SpecialSummon(tc,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP)
		tc:CompleteProcedure()
	end
	aux.RCheckAdditional=nil
	aux.RGCheckAdditional=nil
end
function c10700690.immcon(e)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_RITUAL)
end
function c10700690.efilter(e,te)
	if te:GetHandlerPlayer()==e:GetHandlerPlayer() or not te:IsActivated() then return false end
	if not te:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return true end
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	return not g or not g:IsContains(e:GetHandler())
end
function c10700690.regop(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():RegisterFlagEffect(10700690,RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET+RESET_CHAIN,0,1)
end
function c10700690.damcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local dg=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	if re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) and dg and g:IsContains(e:GetHandler()) then return false end
	return ep~=tp and c:GetFlagEffect(10700690)~=0
end
function c10700690.damop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,10700690)
	Duel.Damage(1-tp,500,REASON_EFFECT)
end
function c10700690.negcon(e,tp,eg,ep,ev,re,r,rp)
	if not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return false end
	local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	if not g or g:GetCount()~=1 then return false end
	local tc=g:GetFirst()
	local c=e:GetHandler()
	return not c:IsStatus(STATUS_BATTLE_DESTROYED) and Duel.IsChainNegatable(ev)
end
function c10700690.negtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
	if e:GetHandler():GetSequence()>4 and Duel.GetFieldGroupCount(1-tp,LOCATION_HAND,0)>0 then
		e:SetCategory(CATEGORY_CATEGORY_HANDES)
	end
end
function c10700690.negop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then 
		if Duel.Destroy(eg,REASON_EFFECT)>0 and Duel.GetFieldGroupCount(1-tp,LOCATION_HAND,0)>0
		  and Duel.SelectYesNo(tp,aux.Stringid(10700690,3)) then
			local g=Duel.GetFieldGroup(1-tp,LOCATION_HAND,0):RandomSelect(1-tp,1)
			Duel.SendtoGrave(g,REASON_EFFECT)
		end
	end
end