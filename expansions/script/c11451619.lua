--幽玄万象图※太虚六爻
--21.09.21
local cm,m=GetID()
cm.IsFusionSpellTrap=true
function cm.initial_effect(c)
	--fusion set
	aux.AddFusionProcFunRep2(c,cm.ffilter,2,63,true)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DECKDES)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
	--contact fusion set
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,3))
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetCondition(cm.setcon)
	e2:SetOperation(cm.setop)
	c:RegisterEffect(e2)
	--type
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_RANGE+EFFECT_FLAG_SET_AVAILABLE)
	e5:SetCode(EFFECT_REMOVE_TYPE)
	e5:SetRange(0xff)
	e5:SetValue(TYPE_FUSION)
	c:RegisterEffect(e5)
end
function cm.ffilter(c,fc,sub,mg,sg)
	return c:IsLevelAbove(1) and (not sg or not sg:IsExists(Card.IsLevel,1,c,c:GetLevel()))
end
function cm.dptcheck(g)
	return g:GetClassCount(Card.GetLevel)==#g
end
function cm.cfilter(c)
	return c:IsLevelAbove(1) and c:IsReleasable()
end
function cm.setcon(e,tp,eg,ep,ev,re,r,rp)
	local mg=Duel.GetMatchingGroup(cm.cfilter,tp,LOCATION_MZONE,0,nil)
	return mg:CheckSubGroup(cm.dptcheck,2,99) and e:GetHandler():IsSSetable() and Duel.GetTurnPlayer()==tp and (Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2)
end
function cm.setop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local mg=Duel.GetMatchingGroup(cm.cfilter,tp,LOCATION_MZONE,0,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local tg=mg:SelectSubGroup(tp,cm.dptcheck,true,2,99)
	if tg and #tg>0 then
		c:SetMaterial(tg)
		Duel.Release(tg,REASON_COST+REASON_MATERIAL)
		Duel.BreakEffect()
		Duel.SSet(tp,c)
	end
end
function cm.filter(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEDOWN_DEFENSE)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local ct=e:GetHandler():GetMaterialCount()
	if chk==0 then return ct>0 and Duel.IsPlayerCanDiscardDeck(tp,ct) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	e:SetLabel(ct)
end
function cm.mzfilter(c,tp)
	return c:IsLocation(LOCATION_MZONE) and c:IsFacedown() and c:IsControler(tp) and c:GetSequence()<=4
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local ct=e:GetLabel()
	if not Duel.IsPlayerCanDiscardDeck(tp,ct) then return end
	Duel.ConfirmDecktop(tp,ct)
	local g=Duel.GetDecktopGroup(tp,ct)
	local sg=g:Filter(cm.filter,nil,e,tp)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if ft>1 and Duel.IsPlayerAffectedByEffect(tp,59822133) then ft=1 end
	if #g>0 then
		Duel.DisableShuffleCheck()
		if #sg>0 and ft>0 then
			if #sg>ft then
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
				sg=sg:Select(tp,ft,ft,nil)
			end
			g:Sub(sg)
			Duel.ConfirmCards(1-tp,sg)
			if Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEDOWN_DEFENSE)>0 then
				sg=sg:Filter(cm.mzfilter,nil,tp)
				Duel.ShuffleSetCard(sg)
				if #sg==2 and Duel.SelectYesNo(tp,aux.Stringid(11451619,0)) then
					Duel.SwapSequence(sg:GetFirst(),sg:GetNext())
				end
				if #sg<=2 then return end
				for i=1,10 do
					if not Duel.SelectYesNo(tp,aux.Stringid(11451619,1)) then return end
					Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(11451619,2))
					local wg=sg:Select(tp,2,2,nil)
					Duel.SwapSequence(wg:GetFirst(),wg:GetNext())
				end
			end
		end
		Duel.SendtoGrave(g,REASON_EFFECT+REASON_REVEAL)
	end
end