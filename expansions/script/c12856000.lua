--第一圣域 塔尔塔罗斯
function c12856000.initial_effect(c)
	c:EnableCounterPermit(0xa7d)
	c:SetCounterLimit(0xa7d,12)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_COUNTER)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c12856000.tg)
	e1:SetOperation(c12856000.op)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_COUNTER)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_FZONE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1)
	e2:SetTarget(c12856000.tg2)
	e2:SetOperation(c12856000.op2)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e3:SetCode(EVENT_CHAINING)
	e3:SetRange(LOCATION_FZONE)
	e3:SetOperation(aux.chainreg)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e4:SetCode(EVENT_CHAIN_SOLVED)
	e4:SetRange(LOCATION_FZONE)
	e4:SetOperation(c12856000.op4)
	c:RegisterEffect(e4)
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e5:SetCode(EVENT_CHAIN_END)
	e5:SetRange(LOCATION_FZONE)
	e5:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e5:SetOperation(c12856000.op5)
	c:RegisterEffect(e5)
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e6:SetCode(12856000)
	e6:SetRange(LOCATION_FZONE)
	e6:SetOperation(c12856000.op6)
	c:RegisterEffect(e6)
end
function c12856000.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsCanAddCounter(tp,0xa7d,4,e:GetHandler()) end
	Duel.SetOperationInfo(0,CATEGORY_COUNTER,nil,4,0,0xa7d)
end
function c12856000.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
	c:AddCounter(0xa7d,4)
	end
end
function c12856000.w(c,ct)
	return c:GetCounter(0xa7d)+ct<=12 and c:GetCounter(0xa7d)>0 and c:IsAbleToHand()
end
function c12856000.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local ct=c:GetCounter(0xa7d)
	if chk==0 then return Duel.IsExistingTarget(c12856000.w,tp,4,0,1,nil,ct) and ct<12 end
	Duel.Hint(3,tp,HINTMSG_RTOHAND)
	local tc=Duel.SelectTarget(tp,c12856000.w,tp,4,0,1,1,nil,ct):GetFirst()
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,tc,1,0,0)
	local count=tc:GetCounter(0xa7d)
	Duel.SetOperationInfo(0,CATEGORY_COUNTER,e:GetHandler(),count,0,1)
end
function c12856000.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
	local count=tc:GetCounter(0xa7d)
	local count1=c:GetCounter(0xa7d)
		if Duel.SendtoHand(tc,nil,REASON_EFFECT)>0 and tc:IsLocation(LOCATION_HAND) and c:IsRelateToEffect(e) then
		if count+count1>12 then return end
		Duel.BreakEffect()
		c:AddCounter(0xa7d,count)
		end
	end
end
function c12856000.op4(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:GetFlagEffect(FLAG_ID_CHAINING)>0 then
	c:AddCounter(0xa7d,1)
	Duel.RegisterFlagEffect(tp,12856000,RESET_PHASE+PHASE_END,0,1)
	end
end
function c12856000.op5(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFlagEffect(tp,12856000)>0 then
	Duel.ResetFlagEffect(tp,12856000)
		if not e:GetHandler():IsDisabled() then
		Duel.RaiseEvent(e:GetHandler(),12856000,e,0,dp,0,0)
		end
	end
end
function c12856000.RitualCheckEqual(g,c,lv,count)
	if g:GetSum(Card.GetRitualLevel,c)>lv then return end
	if g:CheckWithSumEqual(Card.GetRitualLevel,lv,#g,#g,c) then return true end
	return g:GetSum(Card.GetRitualLevel,c)<lv and (g:GetSum(Card.GetRitualLevel,c)+count)>=lv
end
function c12856000.RitualCheck(g,tp,c,lv,count)
	return c12856000.RitualCheckEqual(g,c,lv,count) and Duel.GetMZoneCount(tp,g,tp)>0 and (not c.mat_group_check or c.mat_group_check(g,tp)) and (not Auxiliary.RCheckAdditional or Auxiliary.RCheckAdditional(tp,g,c))
end
function c12856000.RitualCheckAdditional(c,lv,count)
	return	function(g)
			local chk1 = (not Auxiliary.RGCheckAdditional or Auxiliary.RGCheckAdditional(g)) 
			local chk2 = g:GetSum(aux.RitualCheckAdditionalLevel,c)<=lv
			local chk3 = (g:GetSum(aux.RitualCheckAdditionalLevel,c)+count)<=lv
				return chk1 and (chk2 or chk3)
			end
end
function c12856000.RitualUltimateFilter(c,e,tp,m1,level_function,count)
	if bit.band(c:GetType(),0x81)~=0x81 or not c:IsSetCard(0x3a7d) or not c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,false,true) then return end
	local mg=m1:Filter(Card.IsCanBeRitualMaterial,c,c)
	mg:RemoveCard(c)
	local lv=level_function(c)
	Auxiliary.GCheckAdditional=c12856000.RitualCheckAdditional(c,lv,count)
	local res=mg:CheckSubGroup(c12856000.RitualCheck,1,lv,tp,c,lv,count)
	Auxiliary.GCheckAdditional=nil
	return res
end
function c12856000.RitualUltimateTarget(e,tp,eg,ep,ev,re,r,rp)
	local mg=Duel.GetRitualMaterial(tp)
	local count=Duel.GetCounter(tp,1,0,0xa7d)
	return Duel.IsExistingMatchingCard(Auxiliary.NecroValleyFilter(c12856000.RitualUltimateFilter),tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil,e,tp,mg,Card.GetLevel,count)
end
function c12856000.RitualUltimateOperation(e,tp,eg,ep,ev,re,r,rp)
	::RitualUltimateSelectStart::
	local mg=Duel.GetRitualMaterial(tp)
	local count=Duel.GetCounter(tp,1,0,0xa7d)
	Duel.Hint(3,tp,HINTMSG_SPSUMMON)
	local tg=Duel.SelectMatchingCard(tp,Auxiliary.NecroValleyFilter(c12856000.RitualUltimateFilter),tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil,e,tp,mg,Card.GetLevel,count)
	local tc=tg:GetFirst()
	local mat
	if tc==nil then return end
	mg=mg:Filter(Card.IsCanBeRitualMaterial,tc,tc)
	mg:RemoveCard(tc)
	Duel.Hint(3,tp,HINTMSG_RELEASE)
	local lv=tc:GetLevel()
	Auxiliary.GCheckAdditional=c12856000.RitualCheckAdditional(tc,lv,count)
	mat=mg:SelectSubGroup(tp,c12856000.RitualCheck,true,1,lv,tp,tc,lv,count)
	Auxiliary.GCheckAdditional=nil
	if not mat then goto RitualUltimateSelectStart end	
	local x=mat:GetSum(function(card) return card:GetRitualLevel(tc) end)
		if x<lv then
		local xx=lv-x
		Duel.RemoveCounter(tp,1,0,0xa7d,xx,REASON_EFFECT)
		end
	tc:SetMaterial(mat)
	Duel.ReleaseRitualMaterial(mat)
	Duel.BreakEffect()
	Duel.SpecialSummon(tc,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP)
	tc:CompleteProcedure()
end
function c12856000.RitualUltimateTarget2(c,e,tp,count)
	return c:IsSetCard(0x3a7d) and c:IsType(TYPE_RITUAL) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,false,true) and c:GetLevel()<=count
end
function c12856000.op6(e,tp,eg,ep,ev,re,r,rp)
	local count=Duel.GetCounter(tp,1,0,0xa7d)
	if (c12856000.RitualUltimateTarget(e,tp,eg,ep,ev,re,r,rp) or Duel.IsExistingMatchingCard(Auxiliary.NecroValleyFilter(c12856000.RitualUltimateTarget2),tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil,e,tp,count)) and Duel.SelectEffectYesNo(tp,e:GetHandler(),aux.Stringid(12856000,0)) then
		if Duel.IsExistingMatchingCard(Auxiliary.NecroValleyFilter(c12856000.RitualUltimateTarget2),tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil,e,tp,count) and Duel.SelectYesNo(tp,aux.Stringid(12856000,1)) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
			Duel.Hint(3,tp,HINTMSG_SPSUMMON)
			local tc=Duel.SelectMatchingCard(tp,Auxiliary.NecroValleyFilter(c12856000.RitualUltimateTarget2),tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil,e,tp,count):GetFirst()
			Duel.RemoveCounter(tp,1,0,0xa7d,tc:GetLevel(),REASON_EFFECT)	
			tc:SetMaterial(nil)
			Duel.SpecialSummon(tc,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP)
			tc:CompleteProcedure()
		else
			c12856000.RitualUltimateOperation(e,tp,eg,ep,ev,re,r,rp)
		end
	end
end