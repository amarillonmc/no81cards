--夜刀神十香 校服
local m=33400306
local cm=_G["c"..m]
function cm.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(nil),1)
	c:EnableReviveLimit()
	 --indes
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,4))
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(cm.indcon)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	--cannot target
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e2:SetCondition(cm.indcon)
	e2:SetValue(aux.tgoval)
	c:RegisterEffect(e2)
	--RT
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,0))
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_BATTLE_DESTROYING)
	e3:SetCost(cm.drcost)
	e3:SetTarget(cm.drtg)
	e3:SetOperation(cm.drop)
	c:RegisterEffect(e3)
	--to hand from grave
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(m,1))
	e4:SetCategory(CATEGORY_TOHAND)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e4:SetCode(EVENT_TO_GRAVE)
	e4:SetCondition(cm.indcon2)
	e4:SetTarget(cm.adtg)
	e4:SetOperation(cm.adop)
	c:RegisterEffect(e4)
end
function cm.mfilter(c)
	return not c:IsType(TYPE_RITUAL)
end
function cm.indcon(e)
	local c=e:GetHandler()
	local mg=c:GetMaterial()
	return  c:GetSummonType()==SUMMON_TYPE_SYNCHRO and mg:GetCount()>0 and not mg:IsExists(cm.mfilter,1,nil)
end
function cm.indcon2(e)
	local c=e:GetHandler()
	local mg=c:GetMaterial()
	return c:IsPreviousLocation(LOCATION_ONFIELD) and c:GetSummonType()==SUMMON_TYPE_SYNCHRO and mg:GetCount()>0 and not mg:IsExists(cm.mfilter,1,nil)
end

function cm.drcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(nil,tp,LOCATION_HAND,0,1,nil) end
	local g=Duel.SelectMatchingCard(tp,nil,tp,LOCATION_HAND,0,1,1,nil)
	 Duel.Release(g,REASON_COST+REASON_RELEASE)
end
function cm.drcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsRelateToBattle() and c:GetBattleTarget():IsType(TYPE_MONSTER)
end
function cm.exfilter0(c)
	return  c:IsLevelAbove(1) and c:IsReleasableByEffect()
end
function cm.filter(c,e,tp)
	return c:IsSetCard(0x341) 
end
function cm.rcheck(tp,g,c)
	return g:FilterCount(Card.IsControler,nil,1-tp)<=1
end
function cm.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local mg=Duel.GetRitualMaterial(tp)
		 mg:Remove(Card.IsLocation,nil,LOCATION_HAND)
		local sg=Duel.GetMatchingGroup(cm.exfilter0,tp,0,LOCATION_MZONE,nil)	  
		aux.RCheckAdditional=cm.rcheck
		local res=Duel.IsExistingMatchingCard(aux.NecroValleyFilter(aux.RitualUltimateFilter),tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil,cm.filter,e,tp,mg,sg,Card.GetLevel,"Greater")
		 aux.RCheckAdditional=nil
		return res
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_GRAVE)
 local c=e:GetHandler()
	local mg3=c:GetMaterial()
if c:GetSummonType()==SUMMON_TYPE_SYNCHRO and mg3:GetCount()>0 and not mg3:IsExists(cm.mfilter,1,nil)  then 
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
	end
end
function cm.drop(e,tp,eg,ep,ev,re,r,rp)
	local mg=Duel.GetRitualMaterial(tp)
	mg:Remove(Card.IsLocation,nil,LOCATION_HAND)
	local sg=Duel.GetMatchingGroup(cm.exfilter0,tp,0,LOCATION_MZONE,nil)  
	aux.RCheckAdditional=cm.rcheck
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tg=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(aux.RitualUltimateFilter),tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil,cm.filter,e,tp,mg,sg,Card.GetLevel,"Greater")
	local tc=tg:GetFirst()
	if tc then
		mg=mg:Filter(Card.IsCanBeRitualMaterial,tc,tc)
		if sg  then
			mg:Merge(sg)
		end
		if tc.mat_filter then
			mg=mg:Filter(tc.mat_filter,tc,tp)
		else
			mg:RemoveCard(tc)
		end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
		aux.GCheckAdditional=aux.RitualCheckAdditional(tc,tc:GetLevel(),"Greater")
		local mat=mg:SelectSubGroup(tp,aux.RitualCheck,false,1,tc:GetLevel(),tp,tc,tc:GetLevel(),"Greater")
		aux.GCheckAdditional=nil
		if not mat or mat:GetCount()==0 then
			aux.RCheckAdditional=nil
			aux.RGCheckAdditional=nil
			return
		end
		tc:SetMaterial(mat)
		Duel.ReleaseRitualMaterial(mat) 
		Duel.BreakEffect()
		Duel.SpecialSummon(tc,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP)
		tc:CompleteProcedure()
	end
  aux.RCheckAdditional=nil
   local c=e:GetHandler()
	local mg3=c:GetMaterial()
	if  c:GetSummonType()==SUMMON_TYPE_SYNCHRO and mg3:GetCount()>0 
	and Duel.IsPlayerCanDraw(tp,1) and not mg3:IsExists(cm.mfilter,1,nil)  then 
	  if  Duel.SelectYesNo(tp,aux.Stringid(m,3)) then
	  Duel.Draw(tp,1,REASON_EFFECT)
	  end
	end
end

function cm.thfilter1(c)
	return c:IsType(TYPE_MONSTER) and c:IsAbleToHand() 
end
function cm.thfilter2(c)
	return c:IsType(TYPE_SPELL) and c:IsAbleToHand() 
end
function cm.thfilter3(c)
	return c:IsType(TYPE_RITUAL) and c:IsAbleToHand() 
end
function cm.adtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.thfilter3,tp,LOCATION_GRAVE,0,1,nil)   
	end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE)
end
function cm.adop(e,tp,eg,ep,ev,re,r,rp)   
	local g1=Duel.GetMatchingGroup(cm.thfilter3,tp,LOCATION_GRAVE,0,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=g1:SelectSubGroup(tp,cm.check,false,1,2) 
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end   
end
function cm.check(g,c)
	if #g==1 then return true end
	local res=0
	if #g==2 then 
	if g:IsExists(cm.thfilter1,1,nil,c) then res=res+1 end
	if g:IsExists(cm.thfilter2,1,nil,c) then res=res+4 end
	return res==5 
	end
end