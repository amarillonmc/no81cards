local s,id,o=GetID()
function s.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddFusionProcFunRep(c,s.ffilter,2,true)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(s.regcon)
	e1:SetOperation(s.regop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_MATERIAL_CHECK)
	e2:SetValue(s.valcheck)
	e2:SetLabelObject(e1)
	c:RegisterEffect(e2)
	if not s.globle_check then
		s.globle_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_CHAIN_SOLVING)
		ge1:SetOperation(s.chainop)
		Duel.RegisterEffect(ge1,0)
		local f1=Card.CheckFusionMaterial
		s.fusg=Group.CreateGroup
		s.chaineffect=nil
		function Card.CheckFusionMaterial(card,Group_fus,Card_g,int_chkf,not_mat)
			local exg=Group.CreateGroup()
			s.fusg=Group.CreateGroup()
			local tp=card:GetControler()
			if card:GetOriginalCode()==id and Duel.IsExistingMatchingCard(s.filter2,tp,LOCATION_MZONE,0,1,nil) then
				local fc=aux.FCheckAdditional or aux.TRUE
				local gc=aux.GCheckAdditional or aux.TRUE
				aux.FCheckAdditional=function(fchk_tp,fchk_sg,fchk_fc)
					local ct=fchk_sg:FilterCount(s.filter1,nil,fchk_tp)
					return fc(fchk_tp,fchk_sg,fchk_fc) and ((ct<=1 and not fchk_sg:IsExists(s.filter2,1,nil)) or ct==0)
				end
				aux.GCheckAdditional=function(tp)
					return  function(gchk_sg)
								local ct=gchk_sg:FilterCount(s.filter1,nil,tp)
								return gc(gchk_sg) and ((ct<=1 and not fchk_sg:IsExists(s.filter2,1,nil)) or ct==0)
							end
				end
				exg=Duel.GetMatchingGroup(s.filter0,tp,LOCATION_DECK,0,nil,card)
				exg=Group.__bxor(exg,Group_fus):Filter(s.filter1,nil,tp)
				if exg:GetCount()>0 then
					if Duel.GetFlagEffect(0,id)~=0 and Duel.GetFlagEffect(0,id+500)==0 then
						Duel.RegisterFlagEffect(0,id+500,RESET_EVENT+RESET_CHAIN,0,1)
						local e1=Effect.CreateEffect(card)
						e1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
						e1:SetCode(EVENT_CHAIN_SOLVED)
						e1:SetLabel(tp)
						e1:SetOperation(s.resetop)
						e1:SetReset(RESET_EVENT+RESET_CHAIN)
						Duel.RegisterEffect(e1,0)
						local e2=e1:Clone()
						e2:SetCode(EVENT_CHAIN_NEGATED)
						Duel.RegisterEffect(e2,0)
					end
					local hg=Group.__add(exg,Group_fus)
					return f1(card,hg,Card_g,int_chkf,not_mat)
				end
			end
			return f1(card,Group_fus,Card_g,int_chkf,not_mat)
		end
		local f2=Duel.SelectFusionMaterial
		function Duel.SelectFusionMaterial(tp,card,mg,gc_nil,chkf)
			if card:GetOriginalCode()==id and Duel.GetFlagEffect(0,id)~=0 and Duel.GetFlagEffect(0,id+500)~=0 then
				local exg=Duel.GetMatchingGroup(s.filter0,tp,LOCATION_DECK,0,nil,card,s.chaineffect)
				if exg:GetCount()>0 then
					mg:Merge(exg)
					s.fusg=exg
				end
			end
			Duel.ResetFlagEffect(0,id+500)
			return f2(tp,card,mg,gc_nil,chkf)
		end
	end
end
function s.ffilter(c,fc,sub,mg,sg)
	if c:IsControler(1-fc:GetControler()) then return false end
	return not sg or sg:FilterCount(aux.TRUE,c)==0
		or (not sg:IsExists(Card.IsFusionAttribute,1,c,c:GetFusionAttribute())
			and not sg:IsExists(Card.IsLevel,1,c,c:GetLevel()))
end
function s.chainop(e,tp,eg,ep,ev,re,r,rp)
	s.chaineffect=re
	Duel.RegisterFlagEffect(0,id,RESET_EVENT+RESET_CHAIN,0,1)
end
function s.resetop(e,tp,eg,ep,ev,re,r,rp)
	Duel.ResetFlagEffect(0,id)
	s.chaineffect=nil
	e:Reset()
end
function s.filter0(c,fc,e)
	return c:IsCanBeFusionMaterial(fc) and (not e or not c:IsImmuneToEffect(e))
end
function s.filter1(c,tp)
	return c:IsLocation(LOCATION_DECK) and c:IsControler(tp)
end
function s.filter2(c)
	return c:IsRace(RACE_SPELLCASTER) and c:IsAttribute(ATTRIBUTE_EARTH) and c:IsFaceup() and c:IsLocation(LOCATION_MZONE)
end
function s.regcon(e,tp,eg,ep,ev,re,r,rp)
	local att,lv=e:GetLabel()
	local g=e:GetLabelObject()
	return e:GetHandler():IsSummonType(SUMMON_TYPE_FUSION) and (lv>0 or (g and #g>0))
end
function s.regop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local att,lv=e:GetLabel()
	local g=e:GetLabelObject()
	if lv>0 then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_LEVEL)
		e1:SetValue(lv)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		c:RegisterEffect(e1)
		if att>0 then
			local e2=e1:Clone()
			e2:SetCode(EFFECT_CHANGE_ATTRIBUTE)
			e2:SetValue(att)
			c:RegisterEffect(e2)
		end
	end
	if g and #g>0 then
		local e3=Effect.CreateEffect(c)
		e3:SetDescription(aux.Stringid(id,0))
		e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
		e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
		e3:SetCode(EVENT_RELEASE)
		e3:SetProperty(EFFECT_FLAG_DELAY)
		e3:SetLabelObject(g)
		e3:SetTarget(s.sptg)
		e3:SetOperation(s.spop)
		e3:SetReset(RESET_EVENT+0x5600000)
		c:RegisterEffect(e3)
	end
end
function s.valcheck(e,c)
	local g=c:GetMaterial()
	if g:FilterCount(Card.IsLocation,nil,LOCATION_DECK)==1 then
		local tc=g:Filter(Card.IsLocation,nil,LOCATION_DECK):GetFirst()
		e:GetLabelObject():SetLabel(tc:GetAttribute(),tc:GetLevel())
	end
	if g:IsExists(Card.IsLocation,1,nil,LOCATION_HAND+LOCATION_MZONE) then
		local sg=g:Filter(Card.IsLocation,nil,LOCATION_HAND+LOCATION_MZONE)
		sg:KeepAlive()
		e:GetLabelObject():SetLabelObject(sg)
	end
end
function s.spfilter(c,e,tp,g)
	return c:IsFaceupEx() and g:IsContains(c) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil,e,tp,e:GetLabelObject()) end
	Duel.SetTargetCard(e:GetLabelObject())
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE+LOCATION_REMOVED)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local g=Duel.GetTargetsRelateToChain()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sg=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(s.spfilter),tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil,e,tp,g)
	if sg:GetCount()>0 then
		Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
	end
end
