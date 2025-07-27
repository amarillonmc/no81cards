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
	e1:SetCountLimit(1,EFFECT_COUNT_CODE_SINGLE)
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
	e2:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
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
		ge0:SetCode(EVENT_CHAINING)
		ge0:SetOperation(function() Duel.ResetFlagEffect(0,m) end)
		Duel.RegisterEffect(ge0,0)
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD)
		ge1:SetCode(EFFECT_ACTIVATE_COST)
		ge1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		ge1:SetTargetRange(1,1)
		ge1:SetOperation(function() Duel.RegisterFlagEffect(0,m,RESET_CHAIN,0,1) end)
		Duel.RegisterEffect(ge1,0)
		local _RegisterEffect=Card.RegisterEffect
		function Card.RegisterEffect(c,e,bool)
			local tp=c:GetControler()
			local extg=Duel.GetMatchingGroup(cm.extfilter,tp,LOCATION_DECK,0,nil)
			local hg=Duel.GetMatchingGroup(Card.IsAbleToGraveAsCost,tp,LOCATION_HAND,0,nil)
			if Duel.GetFlagEffect(0,m)>0 and Duel.GetFlagEffect(1,m)>0 and Duel.IsPlayerAffectedByEffect(1,EFFECT_FLAG_EFFECT+m):GetLabelObject() and Duel.IsPlayerAffectedByEffect(1,EFFECT_FLAG_EFFECT+m):GetLabel()==Duel.GetCurrentChain() then
				return 0
			elseif c:IsLocation(LOCATION_HAND) and e:GetCode()==EFFECT_PUBLIC and e:IsHasType(EFFECT_TYPE_SINGLE) and #extg>0 and c:IsAbleToGraveAsCost() and Duel.GetFlagEffect(0,m)>0 and Duel.SelectEffectYesNo(tp,c,aux.Stringid(m,2)) then
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
				local tc=extg:GetFirst()
				if #extg>1 then tc=extg:Select(tp,1,1,nil):GetFirst() end
				local tc2=c --hg:GetFirst()
				--if #hg>1 then tc2=hg:Select(tp,1,1,nil):GetFirst() end
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
	return c:IsControler(tp) and c:IsLocation(LOCATION_MZONE)
end
function cm.adcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(cm.filter,1,nil,1-tp)
end
function cm.adtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(cm.spfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil,e,tp) and c:GetFlagEffect(m)==0 end
	c:RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD+RESET_CHAIN,0,1)
	Duel.Hint(HINT_OPSELECTED,tp,e:GetDescription())
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
	return c:IsAttribute(ATTRIBUTE_LIGHT) and c:IsLevel(1) and c:IsType(TYPE_TUNER)
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
		return eg:IsExists(cm.filter,1,nil,tp) --Duel.IsExistingMatchingCard(cm.scfilter,tp,LOCATION_EXTRA,0,1,nil,mg,tp)
	end
	Duel.Hint(HINT_OPSELECTED,tp,e:GetDescription())
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	--Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function cm.adop2(e,tp,eg,ep,ev,re,r,rp)
	local g=eg:Filter(cm.filter,nil,tp)
	if #g>0 then
		local tc=g:GetFirst()
		if #g>1 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
			tc=g:Select(tp,1,1,nil):GetFirst()
		end
		Duel.HintSelection(Group.FromCards(tc))
		--destroy
		local e5=Effect.CreateEffect(e:GetHandler())
		e5:SetDescription(aux.Stringid(m,4))
		e5:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
		e5:SetCode(EVENT_LEAVE_FIELD)
		e5:SetOwnerPlayer(tp)
		e5:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CLIENT_HINT)
		e5:SetOperation(cm.desop)
		tc:RegisterEffect(e5,true)
	end
end
function cm.desop(e,tp,eg,ep,ev,re,r,rp)
	local tp=e:GetOwnerPlayer()
	local mg=Duel.GetMatchingGroup(cm.sfilter,tp,LOCATION_DECK,0,nil)
	if #mg>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local tg=mg:Select(tp,1,1,nil)
		Duel.SendtoHand(tg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tg)
	end
	e:Reset()
end
function cm.adop22(e,tp,eg,ep,ev,re,r,rp)
	local mg=Duel.GetMatchingGroup(cm.sfilter,tp,LOCATION_DECK,0,nil)
	local g=Duel.GetMatchingGroup(cm.scfilter,tp,LOCATION_EXTRA,0,nil,mg,tp)
	if #g>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=g:Select(tp,1,1,nil)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SMATERIAL)
		local tg=mg:FilterSelect(tp,cm.cfilter,1,1,nil,sg:GetFirst(),tp)
		Duel.SynchroSummon(tp,sg:GetFirst(),tg:GetFirst())
	end
end