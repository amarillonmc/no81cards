--祭铜祈祷主 奥瑞吉诺
function c22348228.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--summon with s/t
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EFFECT_ADD_EXTRA_TRIBUTE)
	e0:SetTargetRange(LOCATION_SZONE,0)
	e0:SetTarget(aux.TargetBoolFunction(Card.IsType,TYPE_SPELL))
	e0:SetValue(POS_FACEUP_ATTACK)
	c:RegisterEffect(e0)
	--Tribute Summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(22348228,0))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SUMMON_PROC)
	e1:SetTargetRange(LOCATION_HAND,0)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCountLimit(1,22348228)
	e1:SetCondition(c22348228.otcon)
	e1:SetTarget(c22348228.ottg)
	e1:SetOperation(c22348228.otop)
	e1:SetValue(SUMMON_TYPE_ADVANCE)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_SET_PROC)
	c:RegisterEffect(e2)
	--set
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(22348228,0))
	e2:SetCategory(CATEGORY_DECKDES)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_SUMMON_SUCCESS)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCondition(c22348228.setcon)
	e3:SetTarget(c22348228.settg)
	e3:SetOperation(c22348228.setop)
	c:RegisterEffect(e3)
end
--
function c22348228.otfilter(c,e,tp)
	return c:IsType(TYPE_PENDULUM) and c:IsSetCard(0x708) and not c:IsImmuneToEffect(e) and Duel.GetMZoneCount(tp,c)>0
end
function c22348228.otfilter2(c,e)
	return c:IsType(TYPE_PENDULUM) and c:IsSetCard(0x708) and not c:IsImmuneToEffect(e) 
end
function c22348228.otcon(e,c,minc)
	if c==nil then return true end
	local tp=c:GetControler()
	return minc<=2
		and Duel.IsExistingMatchingCard(c22348228.otfilter,tp,LOCATION_ONFIELD,0,1,nil,e,tp)
		and Duel.IsExistingMatchingCard(c22348228.otfilter2,tp,LOCATION_DECK,0,1,nil,e)
end
function c22348228.ottg(e,c)
	local mi,ma=c:GetTributeRequirement()
	return mi<=2 and ma>=2 and c:IsType(TYPE_PENDULUM) and c:IsSetCard(0x708)
end
function c22348228.otop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(22348228,3))
	local g1=Duel.SelectMatchingCard(tp,c22348228.otfilter,tp,LOCATION_ONFIELD,0,1,1,nil,e,tp)
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(22348228,3))
	local g2=Duel.SelectMatchingCard(tp,c22348228.otfilter2,tp,LOCATION_DECK,0,1,1,nil,e)
	g1:Merge(g2)
	Duel.SendtoExtraP(g1,nil,REASON_EFFECT)
	c:SetMaterial(nil)
end
--
function c22348228.setcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_ADVANCE)
end
function c22348228.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>4 end
end
function c22348228.spfilter(c)
	return c:IsSetCard(0x708) and c:IsType(TYPE_PENDULUM) and c:IsAbleToHand()
end
function c22348228.setop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)<=4 then return end
	Duel.ConfirmDecktop(tp,5)
	local g=Duel.GetDecktopGroup(tp,5)
	local ct=g:GetCount()
	if ct>0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and g:FilterCount(c22348228.spfilter,nil)>0
		and Duel.SelectYesNo(tp,aux.Stringid(22348228,2)) then
		Duel.DisableShuffleCheck()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=g:FilterSelect(tp,c22348228.spfilter,1,1,nil,e,tp)
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg)
		ct=g:GetCount()-sg:GetCount()
	end
	if ct>0 then
		Duel.SortDecktop(tp,tp,ct)
		for i=1,ct do
			local mg=Duel.GetDecktopGroup(tp,1)
			Duel.MoveSequence(mg:GetFirst(),SEQ_DECKBOTTOM)
		end
	end
end
