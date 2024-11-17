--幻想山河绘卷 崩落的绯色之渊
local s,id,o=GetID()
function s.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DISABLE+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetTarget(s.thtg)
	e1:SetOperation(s.thop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_FUSION_SUMMON+CATEGORY_FUSION_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCost(s.fcost)
	e2:SetTarget(s.ftg)
	e2:SetOperation(s.fop)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,2))
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
	e3:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e3:SetCondition(s.actcon)
	c:RegisterEffect(e3)
	if not aux.fantasy_check then
		aux.fantasy_check=true
		fantasy_IsAbleToDeck=Card.IsAbleToDeck
		fantasy_IsAbleToDeckAsCost=Card.IsAbleToDeckAsCost
		fantasy_SendtoDeck=Duel.SendtoDeck
		function Card.IsAbleToDeck(card_c)
			if card_c:GetCode()==id and card_c:IsLocation(LOCATION_GRAVE) then
				local pl=0
				if int_player then
					pl=int_player
				else
					pl=card_c:GetOwner()
				end
				if not Duel.IsExistingMatchingCard(s.fantasy_setfilter,pl,LOCATION_GRAVE,0,1,card_c) then return false end
			end
			return fantasy_IsAbleToDeck(card_c,int_player)
		end
		function Card.IsAbleToDeckAsCost(card_c)
			if card_c:GetCode()==id and card_c:IsLocation(LOCATION_GRAVE) then
				local pl=card_c:GetOwner()
				if not Duel.IsExistingMatchingCard(s.fantasy_setfilter,pl,LOCATION_GRAVE,0,1,card_c) then return false end
			end
			return fantasy_IsAbleToDeckAsCost(card_c)
		end
		function Duel.SendtoDeck(card_c_or_g,int_player,int_seq,int_reason)
			if aux.GetValueType(card_c_or_g)=='Group' then
				local g=card_c_or_g:Clone()
				for card_c in aux.Next(card_c_or_g) do
					local pl=0
					if int_player then
						pl=int_player
					else
						pl=card_c:GetOwner()
					end
					if card_c:GetCode()==id and card_c:IsLocation(LOCATION_GRAVE) then
						if not Duel.IsExistingMatchingCard(s.fantasy_setfilter,pl,LOCATION_GRAVE,0,1,card_c_or_g) then
							Duel.Hint(HINT_SELECTMSG,pl,HINTMSG_RTOHAND)
							local g=Duel.SelectMatchingCard(pl,s.fantasy_setfilter,pl,LOCATION_GRAVE,0,1,1,card_c_or_g)
							local tc=g:GetFirst()
							if tc and Duel.SendtoHand(tc,nil,REASON_COST)~=0 then
								Duel.BreakEffect()
							end
						else
							g:Sub(Group.FromCards(card_c))
						end
					end
				end
				return fantasy_SendtoDeck(g,int_player,int_seq,int_reason)
			else
				local pl=0
				if int_player then
					pl=int_player
				else
					pl=card_c_or_g:GetOwner()
				end
				if card_c_or_g:GetCode()==id and card_c_or_g:IsLocation(LOCATION_GRAVE) then
					if not Duel.IsExistingMatchingCard(s.fantasy_setfilter,pl,LOCATION_GRAVE,0,1,card_c_or_g) then return end
					Duel.Hint(HINT_SELECTMSG,pl,HINTMSG_RTOHAND)
					local g=Duel.SelectMatchingCard(pl,s.fantasy_setfilter,pl,LOCATION_GRAVE,0,1,1,card_c_or_g)
					local tc=g:GetFirst()
					if tc and Duel.SendtoHand(tc,nil,REASON_COST)~=0 then
						Duel.BreakEffect()
					end
				end
				return fantasy_SendtoDeck(card_c_or_g,int_player,int_seq,int_reason)
			end
		end
	end
end
s.fantasy_mountains_and_rivers=true
function s.fantasy_setfilter(c)
	return _G["c"..c:GetCode()] and _G["c"..c:GetCode()].fantasy_mountains_and_rivers --and not c:IsCode(id)
		and c:IsAbleToHandAsCost()
end
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToHand,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	local g=Duel.GetMatchingGroup(Card.IsAbleToHand,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local sg=Duel.SelectMatchingCard(tp,Card.IsAbleToHand,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	if #sg>0 then
		Duel.HintSelection(sg)
		if Duel.SendtoHand(sg,nil,REASON_EFFECT)~=0 and sg:FilterCount(Card.IsLocation,nil,LOCATION_HAND+LOCATION_EXTRA)~=0
			and Duel.GetCurrentChain()>3 then
			local dg=Group.CreateGroup()
			for i=1,ev do
				local te,tgp=Duel.GetChainInfo(i,CHAININFO_TRIGGERING_EFFECT,CHAININFO_TRIGGERING_PLAYER)
				if tgp~=tp and Duel.NegateActivation(i) then
					local tc=te:GetHandler()
					if tc:IsRelateToEffect(te) then
						dg:AddCard(tc)
					end
				end
			end
			Duel.SendtoDeck(dg,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
		end
	end
end
function s.actcon(e)
	return Duel.GetCurrentChain()>2
end
function s.fcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToDeckAsCost() end
	Duel.SendtoDeck(e:GetHandler(),nil,SEQ_DECKSHUFFLE,REASON_COST)
end
function s.filter1(c,e)
	return c:IsSetCard(0x1a1) and c:IsType(TYPE_MONSTER) and c:IsAbleToDeck() and c:IsCanBeFusionMaterial() and not c:IsImmuneToEffect(e)
end
function s.filter2(c,e)
	return not c:IsImmuneToEffect(e)
end
function s.spfilter(c,e,tp,m,f,chkf)
	return (not f or f(c))
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false) and c:CheckFusionMaterial(m,nil,chkf)
end
function s.exfilter(c,tp)
	return c:IsControler(tp) and c:IsLocation(LOCATION_GRAVE)
end
function s.fcheck(tp,sg,fc)
	if Duel.GetFlagEffect(tp,id)~=0 then
		return sg:IsExists(Card.IsSetCard,1,nil,0x1a1)
	else
		return sg:IsExists(Card.IsSetCard,1,nil,0x1a1) and not sg:IsExists(s.exfilter,1,nil,tp)
	end
end
function s.ftg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local chkf=tp
		local mg1=Duel.GetFusionMaterial(tp):Filter(s.filter2,nil,e)
		local mg2=Duel.GetOverlayGroup(tp,1,0)
		mg1:Merge(mg2)
		local res=Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg1,nil,chkf)
		if not res then
			local ce=Duel.GetChainMaterial(tp)
			if ce~=nil then
				local fgroup=ce:GetTarget()
				local mg3=fgroup(ce,e,tp)
				local mf=ce:GetValue()
				res=Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg3,mf,chkf)
			end
		end
		return res
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function s.fop(e,tp,eg,ep,ev,re,r,rp)
	local chkf=tp
	local mg1=Duel.GetFusionMaterial(tp):Filter(s.filter2,nil,e)
	local mg2=Duel.GetOverlayGroup(tp,1,0)
	mg1:Merge(mg2)
	local sg1=Duel.GetMatchingGroup(s.spfilter,tp,LOCATION_EXTRA,0,nil,e,tp,mg1,nil,chkf)
	local mg3=nil
	local sg2=nil
	local ce=Duel.GetChainMaterial(tp)
	if ce~=nil then
		local fgroup=ce:GetTarget()
		mg3=fgroup(ce,e,tp)
		local mf=ce:GetValue()
		sg2=Duel.GetMatchingGroup(s.spfilter,tp,LOCATION_EXTRA,0,nil,e,tp,mg3,mf,chkf)
	end
	if sg1:GetCount()>0 or (sg2~=nil and sg2:GetCount()>0) then
		local sg=sg1:Clone()
		if sg2 then sg:Merge(sg2) end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tg=sg:Select(tp,1,1,nil)
		local tc=tg:GetFirst()
		if sg1:IsContains(tc) and (sg2==nil or not sg2:IsContains(tc) or not Duel.SelectYesNo(tp,ce:GetDescription())) then
			local mat1=Duel.SelectFusionMaterial(tp,tc,mg1,nil,chkf)
			tc:SetMaterial(mat1)
			Duel.SendtoGrave(mat1,REASON_EFFECT+REASON_MATERIAL+REASON_FUSION)
			Duel.BreakEffect()
			Duel.SpecialSummon(tc,SUMMON_TYPE_FUSION,tp,tp,false,false,POS_FACEUP)
		else
			local mat2=Duel.SelectFusionMaterial(tp,tc,mg3,nil,chkf)
			local fop=ce:GetOperation()
			fop(ce,e,tp,tc,mat2)
		end
		tc:CompleteProcedure()
	end
end