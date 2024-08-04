--光铸之结界-天之壁
local cm,m=GetID()
function cm.initial_effect(c)
	--activate
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_GRAVE_SPSUMMON)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetRange(LOCATION_SZONE)
	e1:SetCountLimit(3,EFFECT_COUNT_CODE_SINGLE)
	e1:SetCondition(cm.adcon)
	e1:SetTarget(cm.adtg)
	e1:SetOperation(cm.adop)
	c:RegisterEffect(e1)
	local e4=e1:Clone()
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e4)
	--opspsummon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1,m)
	e2:SetCondition(cm.adcon2)
	e2:SetTarget(cm.adtg2)
	e2:SetOperation(cm.adop2)
	c:RegisterEffect(e2)
	local e5=e2:Clone()
	e5:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e5)
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE)
	e6:SetCode(m)
	e6:SetRange(LOCATION_DECK)
	c:RegisterEffect(e6)
	if not cm.global_check then
		cm.global_check=true
		local ge0=Effect.CreateEffect(c)
		ge0:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge0:SetCode(EVENT_CHAIN_SOLVING)
		ge0:SetOperation(function() Duel.RegisterFlagEffect(0,m,RESET_CHAIN,0,1) end)
		Duel.RegisterEffect(ge0,0)
		local _RegisterEffect=Card.RegisterEffect
		function Card.RegisterEffect(c,e,bool)
			local tp=c:GetControler()
			local extg=Duel.GetMatchingGroup(cm.extfilter,tp,LOCATION_DECK,0,nil)
			local hg=Duel.GetMatchingGroup(Card.IsAbleToGraveAsCost,tp,LOCATION_HAND,0,nil)
			if Duel.GetFlagEffect(0,m)==0 and Duel.GetFlagEffect(1,m)>0 and Duel.IsPlayerAffectedByEffect(1,EFFECT_FLAG_EFFECT+m):GetLabelObject() and Duel.IsPlayerAffectedByEffect(1,EFFECT_FLAG_EFFECT+m):GetLabel()==Duel.GetCurrentChain() then
				return 0
			elseif c:IsLocation(LOCATION_HAND) and e:GetCode()==EFFECT_PUBLIC and e:IsHasType(EFFECT_TYPE_SINGLE) and #extg>0 and #hg>0 and Duel.GetFlagEffect(0,m)==0 and Duel.SelectYesNo(tp,aux.Stringid(m,2)) then
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
				local tc=extg:GetFirst()
				if #extg>1 then tc=extg:Select(tp,1,1,nil):GetFirst() end
				local tc2=hg:GetFirst()
				if #hg>1 then tc2=hg:Select(tp,1,1,nil):GetFirst() end
				if tc and tc2 then
					Duel.RegisterFlagEffect(1,m,RESET_CHAIN,0,1)
					Duel.IsPlayerAffectedByEffect(1,EFFECT_FLAG_EFFECT+m):SetLabel(Duel.GetCurrentChain())
					Duel.Hint(HINT_CARD,0,m)
					Duel.RegisterFlagEffect(tp,m,RESET_PHASE+PHASE_END,0,1)
					Duel.ConfirmCards(1-tp,c)
					Duel.SendtoGrave(Group.FromCards(tc,tc2),REASON_EFFECT)
					return 0
				end
			end
			return _RegisterEffect(c,e,bool)
		end
	end
end
function cm.extfilter(c)
	return c:IsHasEffect(m) and c:IsAbleToGraveAsCost()
end
function cm.filter(c,tp)
	return c:IsControler(tp)
end
function cm.adcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(cm.filter,1,nil,1-tp)
end
function cm.adtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(cm.spfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_GRAVE)
end
function cm.spfilter(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsLevel(7)
end
function cm.adop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.GetMatchingGroup(cm.spfilter,tp,LOCATION_HAND,0,nil,e,tp)
	if #g==0 then g=Duel.GetMatchingGroup(aux.NecroValleyFilter(cm.spfilter),tp,LOCATION_GRAVE,0,nil,e,tp) end
	local sg=g:Select(tp,1,1,nil)
	if #sg>0 then Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP) end
end
function cm.adcon2(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(cm.filter,1,nil,tp)
end
function cm.sfilter(c)
	return c:IsAttribute(ATTRIBUTE_LIGHT) and c:IsLevel(1)
end
function cm.cfilter(c,syn,tp)
	local g=aux.GetSynMaterials(tp,syn)
	g:AddCard(c)
	return syn:IsSynchroSummonable(c,g)
end
function cm.scfilter(c,mg,tp)
	return mg:IsExists(cm.cfilter,1,nil,c,tp)
end
function cm.adtg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local mg=Duel.GetMatchingGroup(cm.sfilter,tp,LOCATION_DECK,0,nil)
		return Duel.IsExistingMatchingCard(cm.scfilter,tp,LOCATION_EXTRA,0,1,nil,mg,tp)
	end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function cm.adop2(e,tp,eg,ep,ev,re,r,rp)
	local mg=Duel.GetMatchingGroup(cm.sfilter,tp,LOCATION_DECK,0,nil)
	local g=Duel.GetMatchingGroup(cm.scfilter,tp,LOCATION_EXTRA,0,nil,mg,tp)
	if #g>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=g:Select(tp,1,1,nil)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SMATERIAL)
		local tg=mg:FilterSelect(tp,cm.cfilter,1,1,nil,sg:GetFirst())
		Duel.SynchroSummon(tp,sg:GetFirst(),tg:GetFirst())
	end
end