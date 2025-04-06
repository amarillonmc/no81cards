--寄生植物-炼狱兽
local s,id,o=GetID()
function s.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddFusionProcCodeFun(c,57300279,s.mfilter,1,true,true)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetTarget(s.thtg)
	e1:SetOperation(s.thop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_TODECK)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCondition(s.tdcon)
	e2:SetTarget(s.tdtg)
	e2:SetOperation(s.tdop)
	c:RegisterEffect(e2)
end
function s.mfilter(c)
	return c:IsSetCard(0xa521)
end
function s.thfilter(c)
	return c:IsSetCard(0xa521) and c:IsAbleToHand()
end
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function s.filter0(c)
	return c:IsFaceup() and c:IsCanBeFusionMaterial()
end
function s.filter1(c,e)
	return not c:IsImmuneToEffect(e)
end
function s.filter2(c,e,tp,m,f,gc,chkf)
	return c:IsType(TYPE_FUSION) and (not f or f(c))
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false) and c:CheckFusionMaterial(m,gc,chkf)
end
function s.chkfilter(c,tp)
	return c:IsOnField() and c:IsControler(tp)
end
function s.fcheck(tp,sg,fc)
	return sg:GetCount()<3
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,s.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if #g>0 then
		local bc=g:GetFirst()
		if Duel.SendtoHand(bc,nil,REASON_EFFECT)>0
			and bc:IsLocation(LOCATION_HAND) then
			Duel.ConfirmCards(1-tp,bc)
			Duel.ShuffleHand(tp)
			if Duel.GetLocationCount(tp,LOCATION_MZONE)>0
				and bc:IsCanBeSpecialSummoned(e,0,tp,false,false)
				and bc:IsCode(57300279)
				and Duel.SelectYesNo(tp,aux.Stringid(id,2)) then
				Duel.BreakEffect()
				if Duel.SpecialSummon(bc,0,tp,tp,false,false,POS_FACEUP)~=0 then
					Duel.AdjustAll()
					local chkf=tp
					local mg1=Duel.GetFusionMaterial(tp):Filter(Card.IsOnField,nil)
					local mg2=Duel.GetMatchingGroup(s.filter0,tp,0,LOCATION_MZONE,nil)
					if mg2:GetCount()>0 then
						mg1:Merge(mg2)
					end
					aux.FCheckAdditional=s.fcheck
					local res=Duel.IsExistingMatchingCard(s.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg1,nil,bc,chkf)
					if not res then
						local ce=Duel.GetChainMaterial(tp)
						if ce~=nil then
							local fgroup=ce:GetTarget()
							local mg3=fgroup(ce,e,tp)
							local mf=ce:GetValue()
							res=Duel.IsExistingMatchingCard(s.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg3,mf,bc,chkf)
						end
					end
					if res and Duel.SelectYesNo(tp,aux.Stringid(id,3)) then
						local chkf=tp
						if Duel.GetCurrentPhase()&(PHASE_DAMAGE+PHASE_DAMAGE_CAL)~=0 then return end
						local mg1=Duel.GetFusionMaterial(tp):Filter(Card.IsOnField,nil):Filter(s.filter1,nil,e)
						local mg2=Duel.GetMatchingGroup(s.filter0,tp,0,LOCATION_MZONE,nil):Filter(s.filter1,nil,e)
						if mg2:GetCount()>0 then
							mg1:Merge(mg2)
						end
						local sg1=Duel.GetMatchingGroup(s.filter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg1,nil,bc,chkf)
						local mg3=nil
						local sg2=nil
						local ce=Duel.GetChainMaterial(tp)
						if ce~=nil then
							local fgroup=ce:GetTarget()
							mg3=fgroup(ce,e,tp)
							local mf=ce:GetValue()
							sg2=Duel.GetMatchingGroup(s.filter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg3,mf,bc,chkf)
						end
						if sg1:GetCount()>0 or (sg2~=nil and sg2:GetCount()>0) then
							local sg=sg1:Clone()
							if sg2 then sg:Merge(sg2) end
							Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
							local tg=sg:Select(tp,1,1,nil)
							local tc=tg:GetFirst()
							if sg1:IsContains(tc) and (sg2==nil or not sg2:IsContains(tc) or not Duel.SelectYesNo(tp,ce:GetDescription())) then
								local mat1=Duel.SelectFusionMaterial(tp,tc,mg1,bc,chkf)
								tc:SetMaterial(mat1)
								Duel.SendtoGrave(mat1,REASON_EFFECT+REASON_MATERIAL+REASON_FUSION)
								Duel.BreakEffect()
								Duel.SpecialSummon(tc,SUMMON_TYPE_FUSION,tp,tp,false,false,POS_FACEUP)
							else
								local mat2=Duel.SelectFusionMaterial(tp,tc,mg3,bc,chkf)
								local fop=ce:GetOperation()
								fop(ce,e,tp,tc,mat2)
							end
							tc:CompleteProcedure()
						end
					end
				  aux.FCheckAdditional=nil
				end
			end
		end
	end
end
function s.tdcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_FUSION)
end
function s.tdfilter(c)
	return c:IsFaceupEx() and c:IsSetCard(0xa521) and c:IsType(TYPE_MONSTER) and c:IsAbleToGrave()
end
function s.tdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.tdfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,tp,LOCATION_GRAVE+LOCATION_REMOVED)
end
function s.tdop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,s.tdfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,99,nil)
	Duel.SendtoDeck(g,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
end