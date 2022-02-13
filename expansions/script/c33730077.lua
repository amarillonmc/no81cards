-- 键★高潮 银色 / K.E.Y Climax - Argento
--Scripted by: XGlitchy30
local s,id=GetID()

function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(s.cost)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
	--lp
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(id,1))
	e4:SetCategory(CATEGORY_RECOVER)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetRange(LOCATION_GRAVE)
	e4:SetCost(aux.bfgcost)
	e4:SetTarget(s.lptg)
	e4:SetOperation(s.lpop)
	c:RegisterEffect(e4)
end

function s.filter(c,e,tp,zchk)
	if c:IsLocation(LOCATION_HAND) then
		return c:IsType(TYPE_RITUAL) and c:IsType(TYPE_MONSTER) and c:IsLevel(12) and c:IsAttribute(ATTRIBUTE_WIND) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,true,false)
			and (zchk or Duel.GetLocationCount(tp,LOCATION_MZONE>0))
	else
		return c:IsSetCard(0x5460) and c:IsLevelAbove(12) and c:IsCanBeSpecialSummoned(e,0,tp,true,false)
			and (zchk or Duel.GetLocationCountFromEx(tp,tp,nil,c)>0)
	end
end
function s.fselect(sg,tp)
	return sg:GetSum(Card.GetLevel)==12 and aux.mzctcheck(sg,tp)
end
function s.gcheck(g)
	return g:GetSum(Card.GetLevel)<=12
end
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(1)
	local g=Duel.GetReleaseGroup(tp,true)
	aux.GCheckAdditional=s.gcheck
	if chk==0 then
		local res=g:CheckSubGroup(s.fselect,1,g:GetCount(),tp)
		aux.GCheckAdditional=nil
		return res
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local rg=g:SelectSubGroup(tp,s.fselect,false,1,g:GetCount(),tp)
	aux.GCheckAdditional=nil
	aux.UseExtraReleaseCount(rg,tp)
	Duel.Release(rg,REASON_COST)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local zchk=e:GetLabel()==1
		e:SetLabel(0)
		return Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_HAND+LOCATION_EXTRA,0,1,nil,e,tp,zchk)
	end
	e:SetLabel(0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_EXTRA)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tg=Duel.SelectMatchingCard(tp,s.filter,tp,LOCATION_HAND+LOCATION_EXTRA,0,1,1,nil,e,tp,false)
	local tc=tg:GetFirst()
	if tc then
		local sumtyp=0
		if tc:IsType(TYPE_RITUAL) then
			tc:SetMaterial(nil)
			sumtyp=SUMMON_TYPE_RITUAL
		end
		Duel.SpecialSummon(tc,sumtyp,tp,tp,true,false,POS_FACEUP)
		tc:CompleteProcedure()
	end
end

function s.lptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1000)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,1000)
end
function s.lpop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Recover(p,d,REASON_EFFECT)
end