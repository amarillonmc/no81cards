--星辉末裔 巴雷斯塔
function c33200956.initial_effect(c)
	c:EnableReviveLimit()
	aux.EnablePendulumAttribute(c)
	--ritual summon
	local e0=Effect.CreateEffect(c)
	e0:SetDescription(aux.Stringid(33200956,0))
	e0:SetCategory(CATEGORY_RELEASE+CATEGORY_SPECIAL_SUMMON)
	e0:SetType(EFFECT_TYPE_IGNITION)
	e0:SetRange(LOCATION_PZONE)
	e0:SetCountLimit(1)
	e0:SetTarget(c33200956.sptg)
	e0:SetOperation(c33200956.spop)
	c:RegisterEffect(e0)
	--spsm
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(33200956,2))
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(3,33200956)
	e1:SetCondition(c33200956.rpcon)
	e1:SetOperation(c33200956.rpop)
	c:RegisterEffect(e1)
end


--e0
function c33200956.RitualUltimateFilter(c,filter,e,tp,m1,m2,level_function,greater_or_equal,chk)
	if bit.band(c:GetType(),0x81)~=0x81 or (filter and not filter(c,e,tp,chk))
		or not c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,false,true,POS_FACEUP) then return false end
	local mg=m1:Filter(Card.IsCanBeRitualMaterial,c,c)
	if m2 then
		mg:Merge(m2)
	end
	if c.mat_filter then
		mg=mg:Filter(c.mat_filter,c,tp)
	else
		mg:RemoveCard(c)
	end
	local lv=level_function(c)
	aux.GCheckAdditional=aux.RitualCheckAdditional(c,lv,greater_or_equal)
	local res=mg:CheckSubGroup(aux.RitualCheck,1,lv,tp,c,lv,greater_or_equal)
	aux.GCheckAdditional=nil
	return res
end
function c33200956.rfilter(c,e,tp)
	return c:IsSetCard(0x632a)
end
function c33200956.refilter(c)
	return not c:IsLocation(LOCATION_HAND)
end
function c33200956.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local mg=Duel.GetRitualMaterial(tp):Filter(c33200951.refilter,nil)
	local mg2=Duel.GetMatchingGroup(Card.IsReleasable,tp,LOCATION_PZONE,0,e:GetHandler())
	mg:Merge(mg2)
	if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>4 and mg:GetCount()>0 end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c33200956.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)<=4 then return end
	Duel.ConfirmDecktop(tp,5)
	local g=Duel.GetDecktopGroup(tp,5):Filter(c33200956.rfilter,nil,e,tp)
	local mg=Duel.GetRitualMaterial(tp):Filter(c33200956.refilter,nil)
	local mg2=Duel.GetMatchingGroup(Card.IsReleasable,tp,LOCATION_PZONE,0,e:GetHandler())
	local smg=g:Filter(c33200956.RitualUltimateFilter,nil,c33200956.rfilter,e,tp,mg,mg2,Card.GetLevel,"Greater")
	if smg:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(33200956,1)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tg=smg:Select(tp,1,1,nil)
		local tc=tg:GetFirst()
		if tc then
			mg=mg:Filter(Card.IsCanBeRitualMaterial,tc,tc)
			mg:Merge(mg2)
			if tc.mat_filter then
				mg=mg:Filter(tc.mat_filter,tc,tp)
			else
				mg:RemoveCard(tc)
			end
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
			aux.GCheckAdditional=aux.RitualCheckAdditional(tc,tc:GetLevel(),"Greater")
			local mat=mg:SelectSubGroup(tp,aux.RitualCheck,false,1,tc:GetLevel(),tp,tc,tc:GetLevel(),"Greater")
			aux.GCheckAdditional=nil
			if not mat or mat:GetCount()==0 then return end
			tc:SetMaterial(mat)
			Duel.ReleaseRitualMaterial(mat)
			Duel.BreakEffect()
			Duel.SpecialSummon(tc,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP)
			tc:CompleteProcedure()
		end
	end
	Duel.ShuffleDeck(tp)
end

--e1
function c33200956.rpcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_RITUAL) or e:GetHandler():IsSummonType(SUMMON_TYPE_PENDULUM)
end
function c33200956.rpop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_CHANGE_LEVEL)
	e0:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e0:SetRange(LOCATION_MZONE)
	e0:SetValue(8)
	e0:SetReset(RESET_EVENT+0xff0000)
	c:RegisterEffect(e0)
	--atk up
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetCondition(c33200956.atkcon)
	e1:SetValue(c33200956.atkval)
	e1:SetReset(RESET_PHASE+PHASE_END,2)
	Duel.RegisterEffect(e1,tp)
end
function c33200956.atkcon(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	return ph>=PHASE_BATTLE_START and ph<=PHASE_BATTLE
end
function c33200956.atkval(e,c)
	local tp=e:GetHandlerPlayer()
	local p1=0
	local p2=0
	if not Duel.CheckLocation(tp,LOCATION_PZONE,0) then
		p1=Duel.GetFieldCard(tp,LOCATION_PZONE,0):GetRightScale()
	end
	if not Duel.CheckLocation(tp,LOCATION_PZONE,1) then
		p2=Duel.GetFieldCard(tp,LOCATION_PZONE,1):GetLeftScale()
	end
	return (p1+p2)*100
end