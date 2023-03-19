--暗月巧壳 艾露-魔导模式
function c67200570.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,nil,4,2,c67200570.ovfilter,aux.Stringid(67200570,0),2,c67200570.xyzop)
	c:EnableReviveLimit()   

end
function c67200570.ovfilter(c)
	return c:IsFaceup() and c:IsCode(67200551)
end
function c67200570.xyzop(e,tp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,67200570)==0 end
	Duel.RegisterFlagEffect(tp,67200570,RESET_PHASE+PHASE_END,EFFECT_FLAG_OATH,1)
end