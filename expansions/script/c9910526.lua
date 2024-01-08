--桃绯巫女 八岐雪花
function c9910526.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--atk down
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetTargetRange(0,LOCATION_MZONE)
	e1:SetValue(c9910526.atkval)
	c:RegisterEffect(e1)
	--cardtarget
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(9910526,0))
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,9910526)
	e2:SetCondition(c9910526.ctgcon)
	e2:SetTarget(c9910526.ctgtg)
	e2:SetOperation(c9910526.ctgop)
	c:RegisterEffect(e2)
	--Destroy
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e3:SetCode(EVENT_LEAVE_FIELD_P)
	e3:SetOperation(c9910526.checkop)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
	e4:SetCode(EVENT_LEAVE_FIELD)
	e4:SetOperation(c9910526.desop)
	e4:SetLabelObject(e3)
	c:RegisterEffect(e4)
	--remove
	local e5=Effect.CreateEffect(c)
	e5:SetCategory(CATEGORY_REMOVE)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e5:SetCode(EVENT_RELEASE)
	e5:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e5:SetCountLimit(1,9910535)
	e5:SetTarget(c9910526.rmtg)
	e5:SetOperation(c9910526.rmop)
	c:RegisterEffect(e5)
	c9910526.tsukisome_release_effect=e5
end
function c9910526.atkfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xa950) and c:GetLevel()>0
end
function c9910526.atkval(e)
	local lg=Duel.GetMatchingGroup(c9910526.atkfilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,nil)
	return lg:GetSum(Card.GetLevel)*-50
end
function c9910526.ctgcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(Card.IsSummonPlayer,1,e:GetHandler(),1-tp)
end
function c9910526.ctgfilter(c,tg)
	return c:IsFaceup() and (not tg or not tg:IsContains(c) or c:GetFlagEffect(9910535)==0)
end
function c9910526.ctgtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	local tg=c:GetCardTarget()
	if chkc then return chkc:IsOnField() and chkc:IsControler(1-tp) and c9910526.ctgfilter(chkc,tg) end
	if chk==0 then return Duel.IsExistingTarget(c9910526.ctgfilter,tp,0,LOCATION_ONFIELD,1,nil,tg) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,c9910526.ctgfilter,tp,0,LOCATION_ONFIELD,1,1,nil,tg)
end
function c9910526.ctgop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and tc:IsFaceup() and tc:IsRelateToEffect(e) then
		c:SetCardTarget(tc)
		local fid=c:GetFieldID()
		c:RegisterFlagEffect(9910526,RESET_EVENT+RESETS_STANDARD,0,1,fid)
		tc:RegisterFlagEffect(9910535,RESET_EVENT+RESETS_STANDARD,0,1,fid)
	end
end
function c9910526.checkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsDisabled() and c:GetFlagEffectLabel(9910526) then
		e:SetLabel(c:GetFlagEffectLabel(9910526))
	else e:SetLabel(0) end
end
function c9910526.ctgfilter2(c,fid)
	return c:IsOnField() and c:GetFlagEffectLabel(9910535)==fid
end
function c9910526.desop(e,tp,eg,ep,ev,re,r,rp)
	local lab=e:GetLabelObject():GetLabel()
	if lab==0 then return end
	local g=e:GetHandler():GetCardTarget()
	local tg=g:Filter(c9910526.ctgfilter2,nil,lab)
	if tg:GetCount()>0 then
		Duel.Destroy(tg,REASON_EFFECT)
	end
end
function c9910526.rmfilter1(c)
	return c:IsAbleToRemove() and c:IsSetCard(0xa950)
end
function c9910526.rmfilter2(c,g)
	return c:IsAbleToRemove() and g:IsExists(Card.IsType,1,nil,c:GetOriginalType()&0x7)
end
function c9910526.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(c9910526.rmfilter1,tp,LOCATION_GRAVE,0,nil)
	if chk==0 then return #g>1 and Duel.IsExistingMatchingCard(c9910526.rmfilter2,tp,0,LOCATION_ONFIELD,1,nil,g) end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,1-tp,LOCATION_ONFIELD)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,2,tp,LOCATION_GRAVE)
end
function c9910526.gcheck(g,type1)
	return g:IsExists(Card.IsType,1,nil,type1)
end
function c9910526.rmop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c9910526.rmfilter1,tp,LOCATION_GRAVE,0,nil)
	if #g<2 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local sg1=Duel.SelectMatchingCard(tp,c9910526.rmfilter2,tp,0,LOCATION_ONFIELD,1,1,nil,g)
	local tc=sg1:GetFirst()
	if tc then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local sg2=g:SelectSubGroup(tp,c9910526.gcheck,false,2,2,tc:GetOriginalType()&0x7)
		if #sg2==2 then
			sg1:Merge(sg2)
			Duel.HintSelection(sg1)
			Duel.Remove(sg1,POS_FACEUP,REASON_EFFECT)
		end
	end
end
