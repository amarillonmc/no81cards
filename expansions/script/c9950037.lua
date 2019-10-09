--自由佣兵的剑士·琪露诺
function c9950037.initial_effect(c)
	c:EnableReviveLimit()
	 --
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(9950037,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_RELEASE)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e1:SetCountLimit(1,99500370)
	e1:SetTarget(c9950037.tg1)
	e1:SetOperation(c9950037.op1)
	c:RegisterEffect(e1)
	--destroy
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(9950037,1))
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetTarget(c9950037.destg)
	e2:SetOperation(c9950037.desop)
	c:RegisterEffect(e2)
	--destroy
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(9950037,4))
	e3:SetCategory(CATEGORY_REMOVE)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetCountLimit(1,9950037)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTarget(c9950037.rmtg)
	e3:SetOperation(c9950037.rmop)
	c:RegisterEffect(e3)
	--damage
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DAMAGE)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCode(EVENT_BATTLE_DESTROYING)
	e2:SetCondition(aux.bdocon)
	e2:SetTarget(c9950037.damtg)
	e2:SetOperation(c9950037.damop)
	c:RegisterEffect(e2)
	--spsummon bgm
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e8:SetCode(EVENT_SPSUMMON_SUCCESS)
	e8:SetOperation(c9950037.sumsuc)
	c:RegisterEffect(e8)
	local e9=e8:Clone()
	e9:SetCode(EVENT_SUMMON_SUCCESS)
	c:RegisterEffect(e9)
end
function c9950037.sumsuc(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_MUSIC,0,aux.Stringid(9950037,0))
end
function c9950037.tfilter1(c,tp,mg,rc)
	if c:IsControler(tp) and c:IsLocation(LOCATION_MZONE) and c:GetSequence()<5 then
		Duel.SetSelectedCard(c)
		return mg:CheckWithSumGreater(Card.GetRitualLevel,9,rc)
	else return false end
end
function c9950037.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		local mg=Duel.GetRitualMaterial(tp):Filter(Card.IsCanBeRitualMaterial,c,c)
		local ft=Duel.GetMZoneCount(tp)
		if not c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,false,true) then return false end
		if ft>0 then
			return mg:CheckWithSumGreater(Card.GetRitualLevel,9,c)
		else
			return mg:IsExists(c9950037.tfilter1,1,nil,tp,mg,c)
		end
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_GRAVE)
end
function c9950037.op1(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetHandler()
	local mg=Duel.GetRitualMaterial(tp)
	local ft=Duel.GetMZoneCount(tp)
	if tc then
		mg=mg:Filter(Card.IsCanBeRitualMaterial,tc,tc)
		local mat=nil
		if ft>0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
			mat=mg:SelectWithSumGreater(tp,Card.GetRitualLevel,9,tc)
		else
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
			mat=mg:FilterSelect(tp,c9950037.tfilter1,1,1,nil,tp,mg,tc)
			Duel.SetSelectedCard(mat)
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
			local mat2=mg:SelectWithSumGreater(tp,Card.GetRitualLevel,9,tc)
			mat:Merge(mat2)
		end
		tc:SetMaterial(mat)
		Duel.ReleaseRitualMaterial(mat)
		e:SetLabel(mat:GetCount())
		if not tc:IsRelateToEffect(e) then return end
		Duel.BreakEffect()
		Duel.SpecialSummon(tc,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP)
		tc:CompleteProcedure()
	end
end
function c9950037.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local c1=Duel.GetMatchingGroupCount(aux.TRUE,tp,0,LOCATION_MZONE,nil)
	local c2=Duel.GetMatchingGroupCount(aux.TRUE,tp,0,LOCATION_SZONE,nil)
	if (c1>c2 and c2~=0) or c1==0 then c1=c2 end
	if c1~=0 then
		local g=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_ONFIELD,nil)
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,c1,0,0)
	end
end
function c9950037.desop(e,tp,eg,ep,ev,re,r,rp)
	local g1=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_MZONE,nil)
	local g2=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_SZONE,nil)
	if g1:GetCount()>0 or g2:GetCount()>0 then
		if g1:GetCount()==0 then
			Duel.Destroy(g2,REASON_EFFECT)
		elseif g2:GetCount()==0 then
			Duel.Destroy(g1,REASON_EFFECT)
		else
			Duel.Hint(HINT_SELECTMSG,tp,0)
			local ac=Duel.SelectOption(tp,aux.Stringid(9950037,2),aux.Stringid(9950037,3))
			if ac==0 then Duel.Destroy(g1,REASON_EFFECT)
			else Duel.Destroy(g2,REASON_EFFECT) end
		end
	end
end
function c9950037.desfilter3(c,g)
	return g:IsContains(c)
end
function c9950037.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local cg=e:GetHandler():GetColumnGroup()
	local g=Duel.GetMatchingGroup(c9950037.desfilter3,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil,cg)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,g:GetCount(),0,0)
end
function c9950037.rmop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local cg=c:GetColumnGroup()
	if c:IsRelateToEffect(e) and c:IsFaceup() then
		local g=Duel.GetMatchingGroup(c9950037.desfilter3,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil,cg)
		if g:GetCount()>0 then
			Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
			Duel.Hint(HINT_MUSIC,0,aux.Stringid(9950037,0))
		end
	end
end
function c9950037.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local bc=e:GetHandler():GetBattleTarget()
	local dam=bc:GetTextAttack()
	if chk==0 then return dam>0 end
	Duel.SetTargetCard(bc)
	Duel.SetTargetPlayer(1-tp)
	Duel.SetTargetParam(dam)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,dam)
end
function c9950037.damop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
		local dam=tc:GetTextAttack()
		if dam<0 then dam=0 end
		Duel.Damage(p,dam,REASON_EFFECT)
	end
end
