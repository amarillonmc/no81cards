--阿尔弗雷德的宣告
function c40009168.initial_effect(c)
	--effect
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,40009168+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c40009168.target)
	e1:SetOperation(c40009168.activate)
	c:RegisterEffect(e1)	
end
function c40009168.battlecheck(tp)
	if not Duel.CheckEvent(EVENT_BATTLED) then return false end
	local a=Duel.GetAttacker()
	local d=Duel.GetAttackTarget()
	if not d then return false end
	if d:IsControler(tp) then a,d=d,a end
	local res=a:IsType(TYPE_LINK) and a:IsSetCard(0xaf1d)
		and d:IsStatus(STATUS_BATTLE_DESTROYED) and Duel.IsPlayerCanDraw(tp,a:GetLink())
	return res,a
end
function c40009168.gvfilter(c)
	return c:IsFaceup() and c:IsCode(40009154) and c:IsAbleToGrave() 
end
function c40009168.spfilter(c,e,tp)
	return c:IsSetCard(0x1f1e) and c:IsCanBeSpecialSummoned(e,0,tp,true,false)
end
function c40009168.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local b1=Duel.IsExistingTarget(c40009168.gvfilter,tp,LOCATION_MZONE,0,1,nil) 
	local b2,a=c40009168.battlecheck(tp)
	if chk==0 then return b1 or b2 end
	if b1 then
		e:SetLabel(1)
		Duel.SelectOption(tp,aux.Stringid(40009168,0))
		e:SetCategory(CATEGORY_TOGRAVE+CATEGORY_SPECIAL_SUMMON)
		e:SetProperty(EFFECT_FLAG_CARD_TARGET)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local g=Duel.SelectTarget(tp,c40009168.gvfilter,tp,LOCATION_MZONE,0,1,1,nil)
		Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,1,0,0)
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK+LOCATION_HAND)
		Duel.SetChainLimit(c40009168.chlimit)
	else
		e:SetLabel(2)
		Duel.SelectOption(tp,aux.Stringid(40009168,1))
		e:SetCategory(CATEGORY_DRAW)
		e:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_PLAYER_TARGET)
		e:SetLabelObject(a)
		Duel.SetTargetPlayer(tp)
		Duel.SetTargetParam(a:GetLink())
		Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,a:GetLink())
	end
end
function c40009168.activate(e,tp,eg,ep,ev,re,r,rp)
	if e:GetLabel()==1 then
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		if Duel.SendtoGrave(tc,REASON_EFFECT)~=0 and tc:IsLocation(LOCATION_GRAVE)
			and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
			and Duel.IsExistingMatchingCard(c40009168.spfilter,tp,LOCATION_DECK+LOCATION_HAND,0,1,nil,e,tp) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local g=Duel.SelectMatchingCard(tp,c40009168.spfilter,tp,LOCATION_DECK+LOCATION_HAND,0,1,1,nil,e,tp)
			if g:GetCount()>0 then
				Duel.SpecialSummon(g,0,tp,tp,true,false,POS_FACEUP)
			end
		end
	end
	else
		local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
		local a=e:GetLabelObject()
		if a:IsRelateToBattle() then
			Duel.Draw(p,a:GetLink(),REASON_EFFECT)
		end
	end
end
function c40009168.chlimit(e,ep,tp)
	return tp==ep
end