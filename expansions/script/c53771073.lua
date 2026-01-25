--通常陷阱2
if not require and dofile then function require(str) return dofile(str..".lua") end end
if not pcall(function() require("expansions/script/c53702500") end) then require("script/c53702500") end
function c53771073.initial_effect(c)
	SNNM.Sarcoveil_Sort(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_POSITION+CATEGORY_MSET)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,53771073+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c53771073.target)
	e1:SetOperation(c53771073.activate)
	c:RegisterEffect(e1)
	--destroy
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_CUSTOM+53771073)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_EVENT_PLAYER+EFFECT_FLAG_CARD_TARGET)
	e2:SetCost(c53771073.descost)
	e2:SetTarget(c53771073.destg)
	e2:SetOperation(c53771073.desop)
	c:RegisterEffect(e2)
	--
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e0:SetCode(EVENT_REMOVE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e0:SetOperation(c53771073.regop)
	c:RegisterEffect(e0)
end
function c53771073.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(Card.IsSummonLocation,tp,0,LOCATION_MZONE,nil,LOCATION_EXTRA)
	if chk==0 then return #g>0 end
	Duel.SetOperationInfo(0,CATEGORY_POSITION,g,#g,0,0)
end
function c53771073.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsSummonLocation,tp,0,LOCATION_MZONE,nil,LOCATION_EXTRA)
	if #g==0 then return end
	for tc in aux.Next(g) do
		local le={tc:IsHasEffect(EFFECT_IMMUNE_EFFECT)}
		for _,v in pairs(le) do
			local val=v:GetValue()
			v:SetValue(c53771073.chval(val,e))
		end
	end
	if Duel.ChangePosition(g,POS_FACEDOWN_DEFENSE)~=0 then
		local og=Duel.GetOperatedGroup()
		g:Sub(og)
		for tc in aux.Next(og) do
			tc:RegisterFlagEffect(53771073,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(53771073,4))
			tc:SetStatus(STATUS_CANNOT_CHANGE_FORM,false)
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_FIELD)
			e1:SetCode(EFFECT_FLIPSUMMON_COST)
			e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
			e1:SetLabel(2)
			e1:SetLabelObject(tc)
			e1:SetTargetRange(0xff,0xff)
			e1:SetTarget(c53771073.fstg)
			e1:SetCost(SNNM.Sarcoveil_fscost)
			e1:SetOperation(SNNM.Sarcoveil_fsop)
			e1:SetReset(RESET_PHASE+PHASE_END)
			Duel.RegisterEffect(e1,tp)
		end
	end
	Duel.SendtoGrave(g,REASON_RULE,1-tp)
end
function c53771073.chval(_val,ce)
	return function(e,te)
				if te==ce then return false end
				return _val(e,te)
			end
end
function c53771073.fstg(e,c,tp)
	if c:GetFlagEffect(53771073)==0 or e:GetLabelObject()~=c then return false end
	Sarcoveil_Fsing=c
	return true
end
function c53771073.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
end
function c53771073.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chck:IsControler(1-tp) end
	if chk==0 then return true end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,nil,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c53771073.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToChain() then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end
function c53771073.regop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsPreviousLocation(LOCATION_GRAVE) then
		Duel.RaiseSingleEvent(e:GetHandler(),EVENT_CUSTOM+53771073,re,r,rp,Duel.GetTurnPlayer(),0)
	end
end
