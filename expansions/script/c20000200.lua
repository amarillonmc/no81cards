--红莲战士 莫特
local cm,m,o=GetID()
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCost(cm.cos1)
	e1:SetTarget(cm.tg1)
	e1:SetOperation(cm.op1)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_EQUIP)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCondition(cm.con2)
	e2:SetTarget(cm.tg2)
	e2:SetOperation(cm.op2)
	c:RegisterEffect(e2)
end
--e1
function cm.cos1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,e:GetHandler()) end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
end
function cm.tg1f1(c)
	return c:IsAbleToHand() and c:IsSetCard(0x3fd2)
end
function cm.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.tg1f1,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,cm.tg1f1,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
--e2
function cm.con2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()&(PHASE_DAMAGE+PHASE_DAMAGE_CAL)==0
end
function cm.tg2f2(c,e,tp,g,tc,f)
	if not (c:IsType(TYPE_FUSION) and (not f or f(c)) and c:IsSetCard(0x6fd2) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false)) then return false end
	local min,max=aux.GetMaterialListCount(c)
	return g:CheckSubGroup(cm.gchk,min,max,tc,tp,c)
end
function cm.gchk(g,c,tp,fc)
	return g:IsContains(c) and Duel.GetLocationCountFromEx(tp,tp,g,fc)>0 and g:IsExists(cm.cchk,1,nil,g,fc.fmatchk,1,Group.CreateGroup())
end
function cm.cchk(c,g,f,i,sg)
	if type(f[i])=="number" and not (c:IsCode(f[i]) or (c:IsFusionSetCard(0x5fd2) and aux.IsCodeListed(c,f[i]))) then return false end
	if type(f[i])~="number" and not (f[i])(c) then return false end
	return #f==i or g:IsExists(cm.cchk,1,sg,g,f,i+1,sg+c)
end
function cm.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local g=Duel.GetMatchingGroup(Card.IsCanBeFusionMaterial,tp,LOCATION_ONFIELD,0,nil)
		local res=Duel.IsExistingMatchingCard(cm.tg2f2,tp,LOCATION_EXTRA,0,1,nil,e,tp,g,e:GetHandler())
		if Duel.IsExistingMatchingCard(cm.tg2f2,tp,LOCATION_EXTRA,0,1,nil,e,tp,g,e:GetHandler()) then return true end
		local ce=Duel.GetChainMaterial(tp)
		if not ce then return false end
		g=ce:GetTarget()(ce,e,tp)
		local mf=ce:GetValue()
		return Duel.IsExistingMatchingCard(cm.tg2f2,tp,LOCATION_EXTRA,0,1,nil,e,tp,g,e:GetHandler(),mf)
	end
	Duel.Hint(24,0,aux.Stringid(m,0)) 
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function cm.op2(e,tp,eg,ep,ev,re,r,rp)
	local mg1=Duel.GetMatchingGroup(Card.IsCanBeFusionMaterial,tp,LOCATION_ONFIELD,0,nil):Filter(aux.NOT(Card.IsImmuneToEffect),nil,e)
	local sg1=Duel.GetMatchingGroup(cm.tg2f2,tp,LOCATION_EXTRA,0,nil,e,tp,mg1,e:GetHandler())
	local mg2=Group.CreateGroup()
	local sg2=Group.CreateGroup()
	local ce=Duel.GetChainMaterial(tp)
	if ce~=nil then
		mg2=ce:GetTarget()(ce,e,tp)
		local mf=ce:GetValue()
		sg2=Duel.GetMatchingGroup(cm.tg2f2,tp,LOCATION_EXTRA,0,nil,e,tp,mg2,e:GetHandler(),mf)
	end
	if #(sg1+sg2)>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tc=(sg1+sg2):Select(tp,1,1,nil):GetFirst()
		local min,max=aux.GetMaterialListCount(tc)
		if sg1:IsContains(tc) and (not sg2:IsContains(tc) or not Duel.SelectYesNo(tp,ce:GetDescription())) then
			local mat=mg1:SelectSubGroup(tp,cm.gchk,false,min,max,e:GetHandler(),tp,tc)
			tc:SetMaterial(mat)
			Duel.SendtoGrave(mat,REASON_EFFECT+REASON_MATERIAL+REASON_FUSION)
			Duel.BreakEffect()
			Duel.SpecialSummon(tc,SUMMON_TYPE_FUSION,tp,tp,false,false,POS_FACEUP)
		else
			local mat=mg2:SelectSubGroup(tp,cm.gchk,false,min,max,e:GetHandler(),tp,tc)
			local fop=ce:GetOperation()
			fop(ce,e,tp,tc,mat)
		end
		tc:CompleteProcedure()
	end
end