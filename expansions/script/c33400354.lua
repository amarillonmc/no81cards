--夜刀神-孤独
function c33400354.initial_effect(c)
	 --Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,33400354+10000)
	e1:SetTarget(c33400354.target)
	e1:SetOperation(c33400354.activate)
	c:RegisterEffect(e1)
	 --to hand
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_BATTLE_DESTROYING)
	e2:SetCountLimit(1,33400354)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCondition(c33400354.thcon)
	e2:SetTarget(c33400354.thtg)
	e2:SetOperation(c33400354.thop)
	c:RegisterEffect(e2)
end
function c33400354.dfilter(c)
	return c:IsSetCard(0x341) and c:IsLevelAbove(1) and c:IsAbleToGrave()
end
function c33400354.filter(c,e,tp,m,ft)
	if not c:IsSetCard(0x341) or bit.band(c:GetType(),0x81)~=0x81 or not c:IsLevelBelow(8)
		or not c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,false,true) then return false end
	local mg=m:Filter(Card.IsCanBeRitualMaterial,c,c)
	local dg=Duel.GetMatchingGroup(c33400354.dfilter,tp,LOCATION_DECK+LOCATION_EXTRA,0,nil)
	if ft>0 then
		if Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)==0 then
			return mg:CheckWithSumEqual(Card.GetRitualLevel,c:GetLevel(),1,99,c)
			or dg:IsExists(c33400354.dlvfilter,1,nil,tp,mg,c)
		else 
			return mg:CheckWithSumEqual(Card.GetRitualLevel,c:GetLevel(),1,99,c)
		end
	else
		return ft>-1 and mg:IsExists(c33400354.mfilterf,1,nil,tp,mg,dg,c)
	end
end
function c33400354.mfilterf(c,tp,mg,dg,rc)
	if c:IsControler(tp) and c:IsLocation(LOCATION_MZONE) and c:GetSequence()<5 then
		Duel.SetSelectedCard(c)
		return mg:CheckWithSumEqual(Card.GetRitualLevel,rc:GetLevel(),0,99,rc)
			or dg:IsExists(c33400354.dlvfilter,1,nil,tp,mg,rc,c)
	else return false end
end
function c33400354.dlvfilter(c,tp,mg,rc,mc)
	Duel.SetSelectedCard(Group.FromCards(c,mc))
	return mg:CheckWithSumEqual(Card.GetRitualLevel,rc:GetLevel(),0,99,rc)
end
function c33400354.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local mg=Duel.GetRitualMaterial(tp)
		local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
		return Duel.IsExistingMatchingCard(c33400354.filter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil,e,tp,mg,ft)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_GRAVE)
end
function c33400354.activate(e,tp,eg,ep,ev,re,r,rp)
	local m=Duel.GetRitualMaterial(tp)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tg=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c33400354.filter),tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil,e,tp,m,ft)
	local tc=tg:GetFirst()
	if tc then
		local mat,dmat
		local mg=m:Filter(Card.IsCanBeRitualMaterial,tc,tc)
		local dg=Duel.GetMatchingGroup(c33400354.dfilter,tp,LOCATION_DECK+LOCATION_EXTRA,0,nil)
		if ft>0 then
			local b1=dg:IsExists(c33400354.dlvfilter,1,nil,tp,mg,tc)
			local b2=mg:CheckWithSumEqual(Card.GetRitualLevel,tc:GetLevel(),1,99,tc)
			if  Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)==0  then
				if b1 and (not b2 or Duel.SelectYesNo(tp,aux.Stringid(33400354,0))) then
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
				dmat=dg:FilterSelect(tp,c33400354.dlvfilter,1,1,nil,tp,mg,tc)
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
			mat=mg:FilterSelect(tp,c33400354.mfilterf,1,1,nil,tp,mg,dg,tc)
			local b1=dg:IsExists(c33400354.dlvfilter,1,nil,tp,mg,tc,mat:GetFirst())
			Duel.SetSelectedCard(mat)
			local b2=mg:CheckWithSumEqual(Card.GetRitualLevel,tc:GetLevel(),0,99,tc)
			if  Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)==0  then
				if b1 and (not b2 or Duel.SelectYesNo(tp,aux.Stringid(33400354,0))) then
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
				dmat=dg:FilterSelect(tp,c33400354.dlvfilter,1,1,nil,tp,mg,tc,mat:GetFirst())
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

function c33400354.disfilter(c)
	return c:IsFaceup() and not c:IsDisabled() and not c:IsType(TYPE_NORMAL)
end
function c33400354.thcon(e,tp,eg,ep,ev,re,r,rp)
 local c=e:GetHandler()
	local rc=eg:GetFirst()
	return rc:IsRelateToBattle() and rc:IsStatus(STATUS_OPPO_BATTLE)
		and rc:IsFaceup() and rc:IsSetCard(0x341) and rc:IsType(TYPE_RITUAL) and rc:IsControler(tp) 
end
function c33400354.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToHand() end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
end
function c33400354.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SendtoHand(c,nil,REASON_EFFECT)
	end
end
