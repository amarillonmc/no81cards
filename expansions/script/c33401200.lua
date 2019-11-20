--D.A.L反转
function c33401200.initial_effect(c)
	 --Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_TO_GRAVE)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e1:SetCondition(c33401200.condition)
	e1:SetTarget(c33401200.target)
	e1:SetOperation(c33401200.activate)
	c:RegisterEffect(e1)
	--set
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCondition(c33401200.condition2)
	e2:SetTarget(c33401200.settg)
	e2:SetOperation(c33401200.setop)
	c:RegisterEffect(e2)
end
function c33401200.cfilter(c,tp)
	return c:IsReason(REASON_BATTLE+REASON_EFFECT) and c:IsPreviousLocation(LOCATION_MZONE) and c:GetPreviousControler()==tp and c:IsSetCard(0x341)
end
function c33401200.condition(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c33401200.cfilter,1,nil,tp)
end
function c33401200.cfilter2(c,tp,rp)
	return	 c:IsSetCard(0x341) and ((rp==1-tp and c:IsReason(REASON_EFFECT) and c:GetPreviousControler()==tp and c:IsPreviousLocation(LOCATION_ONFIELD)) or c:IsReason(REASON_BATTLE))
end
function c33401200.condition2(e,tp,eg,ep,ev,re,r,rp)
	return aux.exccon(e) and eg:IsExists(c33401200.cfilter2,1,nil,tp,rp)
end
function c33401200.dfilter(c)
	return c:IsSetCard(0x341) and c:IsLevelAbove(1) and c:IsAbleToGrave()
end
function c33401200.filter(c,e,tp,m,ft)
	if not (c:IsCode(33400037) or c:IsCode(33400222) or c:IsCode(33400320))  or bit.band(c:GetType(),0x81)~=0x81
		or not c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,false,true) then return false end
	local mg=m:Filter(Card.IsCanBeRitualMaterial,c,c)
	local dg=Duel.GetMatchingGroup(c33401200.dfilter,tp,LOCATION_DECK+LOCATION_EXTRA,0,nil)
	if ft>0 then
		if Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)<Duel.GetFieldGroupCount(tp,0,LOCATION_MZONE) then
			return mg:CheckWithSumEqual(Card.GetRitualLevel,c:GetLevel(),1,99,c)
			or dg:IsExists(c33401200.dlvfilter,1,nil,tp,mg,c)
		else 
			return mg:CheckWithSumEqual(Card.GetRitualLevel,c:GetLevel(),1,99,c)
		end
	else
		return ft>-1 and mg:IsExists(c33401200.mfilterf,1,nil,tp,mg,dg,c)
	end
end
function c33401200.mfilterf(c,tp,mg,dg,rc)
	if c:IsControler(tp) and c:IsLocation(LOCATION_MZONE) and c:GetSequence()<5 then
		Duel.SetSelectedCard(c)
		return mg:CheckWithSumEqual(Card.GetRitualLevel,rc:GetLevel(),0,99,rc)
			or dg:IsExists(c33401200.dlvfilter,1,nil,tp,mg,rc,c)
	else return false end
end
function c33401200.dlvfilter(c,tp,mg,rc,mc)
	Duel.SetSelectedCard(Group.FromCards(c,mc))
	return mg:CheckWithSumEqual(Card.GetRitualLevel,rc:GetLevel(),0,99,rc)
end
function c33401200.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local mg=Duel.GetRitualMaterial(tp)
		local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
		return Duel.IsExistingMatchingCard(c33401200.filter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil,e,tp,mg,ft)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_GRAVE)
end
function c33401200.activate(e,tp,eg,ep,ev,re,r,rp)
	local m=Duel.GetRitualMaterial(tp)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tg=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c33401200.filter),tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil,e,tp,m,ft)
	local tc=tg:GetFirst()
	if tc then
		local mat,dmat
		local mg=m:Filter(Card.IsCanBeRitualMaterial,tc,tc)
		local dg=Duel.GetMatchingGroup(c33401200.dfilter,tp,LOCATION_DECK+LOCATION_EXTRA,0,nil)
		if ft>0 then
			local b1=dg:IsExists(c33401200.dlvfilter,1,nil,tp,mg,tc)
			local b2=mg:CheckWithSumEqual(Card.GetRitualLevel,tc:GetLevel(),1,99,tc)
			if  Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)<Duel.GetFieldGroupCount(tp,0,LOCATION_MZONE)  then
				if b1 and (not b2 or Duel.SelectYesNo(tp,aux.Stringid(33401200,0))) then
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
				dmat=dg:FilterSelect(tp,c33401200.dlvfilter,1,1,nil,tp,mg,tc)
				Duel.SetSelectedCard(dmat)
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
				mat=mg:SelectWithSumEqual(tp,Card.GetRitualLevel,tc:GetLevel(),0,99,tc)
				mat:Merge(dmat)
				end
			else
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
				mat=mg:SelectWithSumEqual(tp,Card.GetRitualLevel,tc:GetLevel(),1,99,tc)
			end
		else
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
			mat=mg:FilterSelect(tp,c33401200.mfilterf,1,1,nil,tp,mg,dg,tc)
			local b1=dg:IsExists(c33401200.dlvfilter,1,nil,tp,mg,tc,mat:GetFirst())
			Duel.SetSelectedCard(mat)
			local b2=mg:CheckWithSumEqual(Card.GetRitualLevel,tc:GetLevel(),0,99,tc)
			if  Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)<Duel.GetFieldGroupCount(tp,0,LOCATION_MZONE)  then
				if b1 and (not b2 or Duel.SelectYesNo(tp,aux.Stringid(33400354,0))) then
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
				dmat=dg:FilterSelect(tp,c33401200.dlvfilter,1,1,nil,tp,mg,tc,mat:GetFirst())
				mat:Merge(dmat)
				Duel.SetSelectedCard(mat)
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
				local mat2=mg:SelectWithSumEqual(tp,Card.GetRitualLevel,tc:GetLevel(),0,99,tc)
				mat:Merge(mat2)
				end
			else
				Duel.SetSelectedCard(mat)
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
				local mat2=mg:SelectWithSumEqual(tp,Card.GetRitualLevel,tc:GetLevel(),0,99,tc)
				mat:Merge(mat2)
			end
		end
		tc:SetMaterial(mat)
		if dmat then
			mat:Sub(dmat)
			Duel.SendtoGrave(dmat,REASON_EFFECT+REASON_MATERIAL+REASON_RITUAL)
		end
		Duel.ReleaseRitualMaterial(mat)
		Duel.BreakEffect()
		Duel.SpecialSummon(tc,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP)
		tc:CompleteProcedure()  
	end
	Duel.SpecialSummonComplete()
end
function c33401200.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsSSetable() end
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,e:GetHandler(),1,0,0)
end
function c33401200.setop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsSSetable() then
		Duel.SSet(tp,c)
		Duel.ConfirmCards(1-tp,c)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_REDIRECT)
		e1:SetValue(LOCATION_REMOVED)
		c:RegisterEffect(e1)
	end
end
