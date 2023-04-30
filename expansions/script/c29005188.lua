--方舟骑士-夜刀
c29005188.named_with_Arknight=1
function c29005188.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,nil,2,2,c29005188.lcheck)
	c:EnableReviveLimit()
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e1:SetRange(LOCATION_GRAVE)
	e1:SetCountLimit(1,29005188)
	e1:SetCondition(c29005188.spcon)
	e1:SetTarget(c29005188.sptg)
	e1:SetOperation(c29005188.spop)
	c:RegisterEffect(e1)
end
function c29005188.lcheck(g,lc)
	return g:IsExists(Card.IsLinkSetCard,1,nil,0x87af) or g:IsExists(c29005188.filter,1,nil)
end
function c29005188.filter(c)
	return c:IsLinkSetCard(0x87af) or (c:IsSetCard(0x87af) or (_G["c"..c:GetCode()] and  _G["c"..c:GetCode()].named_with_Arknight))
end
function c29005188.spcon(e,tp,eg,ep,ev,re,r,rp)
	return tp==Duel.GetTurnPlayer()
end
function c29005188.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c29005188.spop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToEffect(e) then
		Duel.SpecialSummon(e:GetHandler(),0,tp,tp,false,false,POS_FACEUP)
	end
end