--鹫骑士格里菲
function c95101131.initial_effect(c)
	aux.AddCodeList(c,95101001)
	--pendulum
	aux.EnablePendulumAttribute(c)
	--dice
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(95101131,0))
	e1:SetCategory(CATEGORY_DICE+CATEGORY_SPECIAL_SUMMON+CATEGORY_DECKDES)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,95101131)
	e1:SetTarget(c95101131.dctg)
	e1:SetOperation(c95101131.dcop)
	c:RegisterEffect(e1)
	--gr:pendulum spsummon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(1152)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_TO_HAND)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetRange(LOCATION_PZONE)
	e3:SetCountLimit(1,95101131+1)
	e3:SetCondition(c95101131.pspcon)
	e3:SetTarget(c95101131.psptg)
	e3:SetOperation(c95101131.pspop)
	c:RegisterEffect(e3)
end
function c95101131.dctg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>0 end
	Duel.SetOperationInfo(0,CATEGORY_DICE,nil,0,tp,1)
end
function c95101131.cfilter(c,e,tp)
	return aux.IsCodeListed(c,95101001) and c:IsType(TYPE_PENDULUM) and Duel.GetMZoneCount(tp)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false) or c:IsSetCard(0xbbd) and c:IsSSetable()
end
function c95101131.dcop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)==0 then return end
	local dc=Duel.TossDice(tp,1)
	Duel.ConfirmDecktop(tp,dc)
	local g=Duel.GetDecktopGroup(tp,dc)
	if g:IsExists(c95101131.cfilter,1,nil,e,tp) and Duel.SelectYesNo(tp,aux.Stringid(95101131,2)) then
		Duel.Hint(HINT_SELECTMSG,p,HINTMSG_OPERATECARD)
		local tc=g:FilterSelect(tp,c95101131.cfilter,1,1,nil,e,tp):GetFirst()
		if tc:IsType(TYPE_PENDULUM) then
			Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
		else
			Duel.SSet(tp,tc)
		end
	end
	Duel.ShuffleDeck(tp)
end
function c95101131.chkfilter(c,tp)
	return c:IsPreviousControler(tp) and c:IsPreviousLocation(LOCATION_PZONE)
end
function c95101131.pspcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c95101131.chkfilter,1,nil,tp)
end
function c95101131.psptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetMZoneCount(tp)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c95101131.pspop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
