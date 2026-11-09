--动物朋友 龙薮猫
function c33740045.initial_effect(c)
	aux.AddMaterialCodeList(c,33700055)
	--fusion summon
	c:EnableReviveLimit()
	--aux.AddFusionProcFunRep2(c,c33740045.ffilter,5,283,true)
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_FUSION_MATERIAL)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCondition(c33740045.Fusion_Condition())
	e0:SetOperation(c33740045.Fusion_Operation())
	c:RegisterEffect(e0)
	aux.AddContactFusionProcedure(c,c33740045.mfilter,LOCATION_HAND+LOCATION_MZONE+LOCATION_GRAVE,0,aux.ContactFusionSendToDeck(c)):SetValue(SUMMON_TYPE_FUSION)
	--immune
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(c33740045.efilter)
	c:RegisterEffect(e1)
	--
	local e2=Effect.CreateEffect(c)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_DRAW_PHASE+TIMING_MAIN_END+TIMING_BATTLE_END+TIMING_END_PHASE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,33740045)
	e2:SetTarget(c33740045.sltg)
	e2:SetOperation(c33740045.slop)
	c:RegisterEffect(e2)
end
function c33740045.mfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsAbleToDeckOrExtraAsCost()
end
function c33740045.Fusion_Filter(c,mg,fc,tp,chkf,gc)
	if not c:IsFusionCode(33700055) and not c:IsHasEffect(EFFECT_FUSION_SUBSTITUTE) then return false end
	local g=mg:Filter(c33740045.ffilter,c,tp)
	aux.GCheckAdditional=aux.dncheck
	local res=g:CheckSubGroup(c33740045.Fusion_Gcheck,4,283,fc,tp,c,chkf,gc)
	aux.GCheckAdditional=nil
	return res
end
function c33740045.ffilter(c,tp)
	return c:IsFusionSetCard(0x442) and not c:IsHasEffect(6205579)
end
function c33740045.Fusion_Gcheck(g,fc,tp,ec,chkf,gc)
	local sg=g:Clone()
	sg:AddCard(ec)
	if sg:IsExists(aux.TuneMagicianCheckX,1,nil,sg,EFFECT_TUNE_MAGICIAN_F) then return false end
	if gc and not sg:IsContains(gc) then return false end
	if aux.FCheckAdditional and not aux.FCheckAdditional(tp,sg,fc)
		or aux.FGoalCheckAdditional and not aux.FGoalCheckAdditional(tp,sg,fc) then return false end
	return g:IsExists(Card.IsType,1,nil,TYPE_FUSION+TYPE_SYNCHRO+TYPE_XYZ+TYPE_LINK) and #g==g:GetClassCount(Card.GetFusionCode) and (chkf==PLAYER_NONE or Duel.GetLocationCountFromEx(tp,tp,sg,fc)>0)
end
function c33740045.Fusion_Condition()
	return function(e,g,gc,chkf)
			if g==nil then return aux.MustMaterialCheck(nil,e:GetHandlerPlayer(),EFFECT_MUST_BE_FMATERIAL) end
			local fc=e:GetHandler()
			local tp=e:GetHandlerPlayer()
			if gc then
				if not g:IsContains(gc) then return false end
				return g:IsExists(c33740045.Fusion_Filter,1,nil,g,fc,tp,chkf,gc)
			end
			return g:IsExists(c33740045.Fusion_Filter,1,nil,g,fc,tp,chkf,nil)
		end
end
function c33740045.Fusion_Operation()
	return function(e,tp,eg,ep,ev,re,r,rp,gc,chkf)
			local fc=e:GetHandler()
			local tp=e:GetHandlerPlayer()
			local fg=eg:Clone()
			local g=nil
			local sg=nil
			while not sg do
				if g then
					fg:AddCard(g:GetFirst())
				end
				if gc then
					if c33740045.Fusion_Filter(gc,fg,fc,tp,chkf) then
						g=Group.FromCards(gc)
						fg:RemoveCard(gc)
						local mg=fg:Filter(c33740045.ffilter,fc,tp)
						Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FMATERIAL)
						sg=mg:SelectSubGroup(tp,c33740045.Fusion_Gcheck,false,4,283,fc,tp,g:GetFirst(),chkf,gc)
					else
						Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FMATERIAL)
						g=fg:FilterSelect(tp,c33740045.Fusion_Filter,1,1,nil,fg,fc,tp,chkf,gc)
						fg:Sub(g)
						local mg=fg:Filter(c33740045.ffilter,fc,tp)
						Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FMATERIAL)
						sg=mg:SelectSubGroup(tp,c33740045.Fusion_Gcheck,true,4,283,fc,tp,g:GetFirst(),chkf,gc)
					end
				else
					Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FMATERIAL)
					g=fg:FilterSelect(tp,c33740045.Fusion_Filter,1,1,nil,fg,fc,tp,chkf,nil)
					fg:Sub(g)
					local mg=fg:Filter(c33740045.ffilter,fc,tp)
					aux.GCheckAdditional=aux.dncheck
					Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FMATERIAL)
					sg=mg:SelectSubGroup(tp,c33740045.Fusion_Gcheck,true,4,283,fc,tp,g:GetFirst(),chkf)
					aux.GCheckAdditional=nil
				end
			end
			g:Merge(sg)
			Duel.SetFusionMaterial(g)
		end
end
function c33740045.efilter(e,te)
	return te:GetOwner()~=e:GetOwner()
end
function c33740045.thfilter(c)
	return c:IsSetCard(0x442) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c33740045.spfilter(c,e,tp,chk)
	return c:IsSetCard(0x442) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and (chk==0 or aux.NecroValleyFilter()(c))-- and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0 and c:IsType(TYPE_MONSTER)
end
function c33740045.cfilter(c)
	return c:IsSetCard(0x442) and c:IsAttackAbove(1) and c:IsFaceup()
end
function c33740045.sltg(e,tp,eg,ep,ev,re,r,rp,chk)
	local ph=Duel.GetCurrentPhase()
	local tg=Duel.GetMatchingGroup(Card.IsAbleToGrave,tp,0,LOCATION_MZONE,nil)
	local b1=Duel.IsExistingMatchingCard(c33740045.thfilter,tp,LOCATION_DECK,0,1,nil,0) and ph==PHASE_DRAW
	local b2=Duel.GetMZoneCount(tp)>0 and (ph==PHASE_MAIN1 or ph==PHASE_MAIN2)
		and Duel.IsExistingMatchingCard(c33740045.spfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil,e,tp,0)
	local b3=#tg>0 and (ph>=PHASE_BATTLE_START and ph<=PHASE_BATTLE)
	local b4=Duel.IsExistingMatchingCard(c33740045.cfilter,tp,LOCATION_MZONE,0,1,nil) and ph==PHASE_END
	if chk==0 then return b1 or b2 or b3 or b4 end
	if b1 then
		e:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_GRAVE_ACTION+CATEGORY_TOEXTRA)
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	end
	if b2 then
		e:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_GRAVE_ACTION+CATEGORY_TOEXTRA)
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
	end
	if b3 then
		e:SetCategory(CATEGORY_TOGRAVE+CATEGORY_GRAVE_ACTION+CATEGORY_TOEXTRA)
		Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,tg,#tg,0,0)
	end
	if b4 then
		e:SetCategory(CATEGORY_RECOVER+CATEGORY_GRAVE_ACTION+CATEGORY_TOEXTRA)
		local ct=Duel.GetMatchingGroup(c33740045.cfilter,tp,LOCATION_MZONE,0,nil):GetSum(Card.GetAttack)
		Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,ct)
	end
end
function c33740045.tdfilter(c)
	return c:IsSetCard(0x442) and c:IsType(TYPE_MONSTER) and c:IsAbleToDeck() and aux.NecroValleyFilter()(c)
end
function c33740045.slop(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	local tg=Duel.GetMatchingGroup(Card.IsAbleToGrave,tp,0,LOCATION_MZONE,nil)
	local b1=Duel.IsExistingMatchingCard(c33740045.thfilter,tp,LOCATION_DECK,0,1,nil,0) and ph==PHASE_DRAW
	local b2=Duel.GetMZoneCount(tp)>0 and (ph==PHASE_MAIN1 or ph==PHASE_MAIN2)
		and Duel.IsExistingMatchingCard(c33740045.spfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil,e,tp,0)
	local b3=#tg>0 and (ph>=PHASE_BATTLE_START and ph<=PHASE_BATTLE)
	local b4=Duel.IsExistingMatchingCard(c33740045.cfilter,tp,LOCATION_MZONE,0,1,nil) and ph==PHASE_END
	if b1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local tc=Duel.SelectMatchingCard(tp,c33740045.thfilter,tp,LOCATION_DECK,0,1,1,nil,1):GetFirst()
		if not tc then return end
		--Duel.HintSelection(Group.FromCards(tc))
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
		--if not tc:IsLocation(LOCATION_HAND) or not Duel.SelectYesNo(tp,aux.Stringid(33740045,2)) then return end
	end
	if b2 then
		if Duel.GetMZoneCount(tp)<=0 then return end
		--local ft=Duel.IsPlayerAffectedByEffect(tp,59822133) and 1 or Duel.GetMZoneCount(tp)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sc=Duel.SelectMatchingCard(tp,c33740045.spfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,e,tp,1):GetFirst()
		if sc then
			Duel.SpecialSummon(sc,0,tp,tp,false,false,POS_FACEUP)
		end
	end
	if b3 then
		Duel.SendtoGrave(tg,REASON_EFFECT)
	end
	if b4 then
		local ct=Duel.GetMatchingGroup(c33740045.cfilter,tp,LOCATION_MZONE,0,nil):GetSum(Card.GetAttack)
		Duel.Recover(tp,ct,REASON_EFFECT)
	end
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(c33740045.tdfilter,tp,LOCATION_GRAVE,0,nil)
	if g:CheckSubGroup(aux.dncheck,3,3) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		local sg=g:SelectSubGroup(tp,aux.dncheck,false,3,3)
		Duel.HintSelection(sg)
		Duel.SendtoDeck(sg,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
	elseif not c:IsRelateToChain() then
		Duel.SendtoDeck(c,nil,SEQ_DECKTOP,REASON_EFFECT)
	end
end
