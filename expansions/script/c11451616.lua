--幽玄龙象※坎寄沧波
--21.09.21
local cm,m=GetID()
function cm.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,3))
	e1:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND+CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetRange(LOCATION_HAND)
	e1:SetCode(EVENT_MSET)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,EFFECT_COUNT_CODE_CHAIN)
	e1:SetTarget(cm.sptg)
	e1:SetOperation(cm.spop)
	c:RegisterEffect(e1)
	local e3=e1:Clone()
	e3:SetCode(EVENT_CHANGE_POS)
	e3:SetCondition(cm.spcon2)
	c:RegisterEffect(e3)
	local e4=e1:Clone()
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	e4:SetCondition(cm.spcon2)
	c:RegisterEffect(e4)
	--search
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(11451416,1))
	e2:SetCategory(CATEGORY_REMOVE+CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_FLIP+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,m)
	e2:SetTarget(cm.fstg)
	e2:SetOperation(cm.fsop)
	c:RegisterEffect(e2)
end
function cm.filter11(c)
	return c:IsFacedown() and c:IsLocation(LOCATION_MZONE)
end
function cm.thfilter(c,sc,ec,tp)
	return c:IsRace(RACE_WYRM) and c:IsAbleToHand() and ((c:IsLevel(sc:GetLevel()+ec:GetLevel(),math.abs(sc:GetLevel()-ec:GetLevel())) and sc:IsLevelAbove(1)) or (tp and sc:GetControler()~=tp))
end
function cm.setfilter(c,ec,tp)
	return c:IsAbleToHand() and Duel.IsExistingMatchingCard(cm.thfilter,tp,LOCATION_DECK,0,1,nil,c,ec,tp)
end
function cm.spcon2(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(Card.IsFacedown,1,nil)
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local g=eg:Filter(cm.filter11,nil)
	if chk==0 then return c:IsAbleToDeck() and g:IsExists(cm.setfilter,1,nil,c,tp) end
	--g=g:Filter(cm.setfilter,nil,c,tp)
	Duel.Hint(HINT_OPSELECTED,tp,e:GetDescription())
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	Duel.SetTargetCard(g)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,PLAYER_ALL,LOCATION_DECK+LOCATION_MZONE)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,c,1,tp,LOCATION_HAND)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	if not g or #g==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local sg=g:FilterSelect(tp,Card.IsAbleToHand,1,1,nil)
	--Duel.HintSelection(sg)
	if #sg>0 and Duel.SendtoHand(sg,nil,REASON_EFFECT)>0 and sg:GetFirst():IsLocation(LOCATION_HAND) then
		Duel.ConfirmCards(tp,sg)
		Duel.ConfirmCards(1-tp,sg)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetDescription(aux.Stringid(m,4))
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CLIENT_HINT+EFFECT_FLAG_IGNORE_IMMUNE)
		e1:SetCode(EFFECT_PUBLIC)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		sg:GetFirst():RegisterEffect(e1,true)
		if c:IsRelateToEffect(e) and Duel.SendtoDeck(c,nil,2,REASON_EFFECT)>0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			local tg=Duel.SelectMatchingCard(tp,cm.thfilter,tp,LOCATION_DECK,0,1,1,nil,sg:GetFirst(),c)
			if #tg>0 and Duel.SendtoHand(tg,nil,REASON_EFFECT)>0 then
				Duel.ConfirmCards(1-tp,tg)
				Duel.ShuffleHand(tp)
			end
		end
	end
end
function cm.filter0(c)
	return c:IsOnField() and c:IsAbleToRemove()
end
function cm.filter1(c)
	return c:IsFaceup() and c:IsAbleToRemove() and c:IsCanBeFusionMaterial()
end
function cm.filter2(c,e,tp,m,f,chkf)
	return c:IsType(TYPE_FUSION) and (not f or f(c)) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEDOWN_DEFENSE) and c:CheckFusionMaterial(m,nil,chkf)
end
function cm.filter3(c,e)
	return c:IsOnField() and c:IsAbleToRemove() and not c:IsImmuneToEffect(e)
end
function cm.filter4(c,e)
	return c:IsFaceup() and c:IsAbleToRemove() and c:IsCanBeFusionMaterial() and not c:IsImmuneToEffect(e)
end
function cm.filter5(c,e,tp,m,f,chkf)
	return (c:IsType(TYPE_FUSION) or c.IsFusionSpellTrap) and (not f or f(c)) and (c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEDOWN_DEFENSE) or c:IsSSetable()) and c:CheckFusionMaterial(m,nil,chkf)
end
function cm.filter6(c)
	return c:IsType(TYPE_MONSTER) and c:IsCanBeFusionMaterial() and c:IsAbleToRemove()
end
function cm.fstg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local chkf=tp
		local mg1=Duel.GetFusionMaterial(tp):Filter(cm.filter0,nil)
		local mg2=Duel.GetMatchingGroup(cm.filter1,tp,0,LOCATION_MZONE,nil)
		mg1:Merge(mg2)
		if e:GetHandler():GetColumnGroupCount()==0 then
			local mg3=Duel.GetMatchingGroup(cm.filter6,tp,LOCATION_GRAVE,LOCATION_GRAVE,nil)
			mg1:Merge(mg3)
		end
		local res=Duel.IsExistingMatchingCard(cm.filter5,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg1,nil,chkf)
		if not res then
			local ce=Duel.GetChainMaterial(tp)
			if ce~=nil then
				local fgroup=ce:GetTarget()
				local mg3=fgroup(ce,e,tp)
				local mf=ce:GetValue()
				res=Duel.IsExistingMatchingCard(cm.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg3,mf,chkf)
			end
		end
		return res
	end
	Duel.Hint(HINT_OPSELECTED,tp,e:GetDescription())
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,0,tp,LOCATION_GRAVE)
end
function cm.fsop(e,tp,eg,ep,ev,re,r,rp)
	local chkf=tp
	local mg1=Duel.GetFusionMaterial(tp):Filter(cm.filter3,nil,e)
	local mg2=Duel.GetMatchingGroup(cm.filter4,tp,0,LOCATION_MZONE,nil,e)
	mg1:Merge(mg2)
	if e:GetHandler():GetColumnGroupCount()==0 then
		local mg3=Duel.GetMatchingGroup(cm.filter6,tp,LOCATION_GRAVE,LOCATION_GRAVE,nil)
		mg1:Merge(mg3)
	end
	local sg1=Duel.GetMatchingGroup(cm.filter5,tp,LOCATION_EXTRA,0,nil,e,tp,mg1,nil,chkf)
	local mg3=nil
	local sg2=nil
	local ce=Duel.GetChainMaterial(tp)
	if ce~=nil then
		local fgroup=ce:GetTarget()
		mg3=fgroup(ce,e,tp)
		local mf=ce:GetValue()
		sg2=Duel.GetMatchingGroup(cm.filter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg3,mf,chkf)
	end
	if #sg1>0 or (sg2~=nil and #sg2>0) then
		local sg=sg1:Clone()
		if sg2 then sg:Merge(sg2) end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
		local tg=sg:Select(tp,1,1,nil)
		local tc=tg:GetFirst()
		if sg1:IsContains(tc) and (sg2==nil or not tc:IsType(TYPE_MONSTER) or not sg2:IsContains(tc) or not Duel.SelectYesNo(tp,ce:GetDescription())) then
			local mat1=Duel.SelectFusionMaterial(tp,tc,mg1,nil,chkf)
			tc:SetMaterial(mat1)
			Duel.Remove(mat1,POS_FACEUP,REASON_EFFECT+REASON_MATERIAL+REASON_FUSION)
			Duel.BreakEffect()
			if tc:IsType(TYPE_MONSTER) then
				Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEDOWN_DEFENSE)
				Duel.ConfirmCards(1-tp,tc)
			else
				Duel.SSet(tp,tc)
			end
		else
			local mat2=Duel.SelectFusionMaterial(tp,tc,mg3,nil,chkf)
			local fop=ce:GetOperation()
			local _SpecialSummon=Duel.SpecialSummon
			Duel.SpecialSummon=function(tg,sumtype,sump,tgp,chk,lm,pos,...)
									local res=_SpecialSummon(tg,sumtype,sump,tgp,chk,lm,POS_FACEDOWN_DEFENSE,...)
									if res>0 then Duel.ConfirmCards(1-sump,tg) end
									return res
								end
			fop(ce,e,tp,tc,mat2)
			Duel.SpecialSummon=_SpecialSummon
		end
		tc:CompleteProcedure()
	end
end