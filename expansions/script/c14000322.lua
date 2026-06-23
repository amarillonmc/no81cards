--吞式者的招来
local m=14000322
local cm=_G["c"..m]
cm.named_with_Aotual=1
function cm.initial_effect(c)
	aux.AddCodeList(c,14000325)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(cm.tg)
	e1:SetOperation(cm.op)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetRange(LOCATION_DECK)
	e2:SetCost(cm.costchk)
	c:RegisterEffect(e2)
	--
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_SPSUMMON_PROC_G)
	e3:SetRange(LOCATION_DECK)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE)
	e3:SetCondition(cm.dacon)
	c:RegisterEffect(e3)
end
function cm.AOTU(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_Aotual
end
function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local mg=Duel.GetRitualMaterial(tp)
		return Duel.IsExistingMatchingCard(aux.RitualUltimateFilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil,aux.TRUE,e,tp,mg,nil,Card.GetLevel,"Greater")
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_GRAVE)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,nil,1,0,LOCATION_ONFIELD)
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	local mg=Duel.GetRitualMaterial(tp)
	local tg=Duel.SelectMatchingCard(tp,aux.RitualUltimateFilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil,aux.TRUE,e,tp,mg,nil,Card.GetLevel,"Greater")
	local tc=tg:GetFirst()
	if tc then
		mg=mg:Filter(Card.IsCanBeRitualMaterial,tc,tc)
		if tc.mat_filter then
			mg=mg:Filter(tc.mat_filter,tc,tp)
		else
			mg:RemoveCard(tc)
		end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
		aux.GCheckAdditional=aux.RitualCheckAdditional(tc,tc:GetLevel(),"Greater")
		local mat=mg:SelectSubGroup(tp,aux.RitualCheck,false,1,tc:GetLevel(),tp,tc,tc:GetLevel(),"Greater")
		aux.GCheckAdditional=nil
		if not mat or mat:GetCount()==0 then return end
		tc:SetMaterial(mat)
		local lv=mat:GetSum(Card.GetLevel)
		Duel.ReleaseRitualMaterial(mat)
		Duel.BreakEffect()
		if Duel.SpecialSummon(tc,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP)~=0 then
			tc:CompleteProcedure()
			if tc:IsCode(14000325) then
				b1=Duel.IsExistingMatchingCard(Card.IsAbleToHand,tp,0,LOCATION_GRAVE,1,nil)
			else
				b1=false
			end
			if not tc:IsCode(14000325) then
				b2=Duel.IsExistingMatchingCard(cm.eqfilter,tp,0,LOCATION_MZONE,1,nil) and Duel.GetLocationCount(tp,LOCATION_SZONE)>0
			else
				b2=false
			end
			if (b1 or b2) and Duel.SelectYesNo(tp,aux.Stringid(m,1)) then
				Duel.BreakEffect()
				if b1 then
					Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
					local g=Duel.SelectMatchingCard(tp,Card.IsAbleToHand,tp,0,LOCATION_GRAVE,1,1,nil,tp)
					if g:GetCount()>0 then
						Duel.HintSelection(g)
						Duel.SendtoHand(g,tp,REASON_EFFECT)
					end
				end
				if b2 then
					Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
					local g=Duel.SelectMatchingCard(tp,cm.eqfilter,tp,0,LOCATION_MZONE,1,1,nil)
					if g:GetCount()>0 then
						local ec=g:GetFirst()
						Duel.HintSelection(g)
						Duel.Equip(tp,ec,tc,false)
						local e1=Effect.CreateEffect(e:GetHandler())
						e1:SetProperty(EFFECT_FLAG_OWNER_RELATE)
						e1:SetType(EFFECT_TYPE_SINGLE)
						e1:SetCode(EFFECT_EQUIP_LIMIT)
						e1:SetReset(RESET_EVENT+RESETS_STANDARD)
						e1:SetValue(cm.eqlimit)
						e1:SetLabelObject(tc)
						ec:RegisterEffect(e1)
						--atkup
						local e2=Effect.CreateEffect(e:GetHandler())
						e2:SetType(EFFECT_TYPE_EQUIP)
						e2:SetCode(EFFECT_UPDATE_ATTACK)
						e2:SetValue(800)
						e2:SetReset(RESET_EVENT+RESETS_STANDARD)
						ec:RegisterEffect(e2)
					end
				end
			end
		end
	end
end
function cm.eqfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsAbleToChangeControler()
end
function cm.eqlimit(e,c)
	return c==e:GetLabelObject()
end
function cm.handfilter(c)
	return c:IsCode(14000325) and not c:IsPublic()
end
function cm.costchk(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.handfilter,tp,LOCATION_HAND,0,1,nil) and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local g=Duel.SelectMatchingCard(tp,cm.handfilter,tp,LOCATION_HAND,0,1,1,nil)
	local tc=g:GetFirst()
	Duel.ConfirmCards(1-tp,tc)
	Duel.ShuffleHand(tp)
	Duel.MoveToField(e:GetHandler(),tp,tp,LOCATION_SZONE,POS_FACEUP,true)
end
function cm.dacon(e,tp,eg,ep,ev,re,r,rp)
	local tp=e:GetHandlerPlayer()
	return Duel.IsExistingMatchingCard(cm.handfilter,tp,LOCATION_HAND,0,1,nil) and Duel.GetLocationCount(tp,LOCATION_SZONE)>0
end